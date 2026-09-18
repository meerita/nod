//! Owns the `qemu-virt` machine composition and its bring-up console.
//!
//! Declares the EL1 profile. Provides the M0 `BootConsole` as raw
//! semihosting calls, which bypass guest/host isolation and therefore
//! stay confined to boot and panic paths, never a production console.
//!
//! This module does not own architecture entry state or device programming.

// Operation numbers from the Arm semihosting specification.
const SYS_WRITEC: usize = 0x03;
const SYS_EXIT: usize = 0x18;
const SYS_EXIT_EXTENDED: usize = 0x20;
const APP_EXIT: usize = 0x20026;

const BOOT_LINE: &[u8] = b"nod M0 EL1 boot\n";
const PANIC_LINE: &[u8] = b"nod M0 panic\n";

/// Boots the M0 kernel on `qemu-virt`.
///
/// Entry contract: called once at EL1 with SP set and `DAIF` masked.
/// Prints the fixed boot line, requests guest exit, and parks.
pub fn boot() -> ! {
    write_bytes(BOOT_LINE);
    exit_clean();
    crate::arch::aarch64::park()
}

/// Reports a kernel panic on `qemu-virt`.
///
/// Prints the fixed panic line, requests guest exit with a nonzero
/// status, and parks.
pub fn panic() -> ! {
    write_bytes(PANIC_LINE);
    exit_with_code(1);
    crate::arch::aarch64::park()
}

fn write_bytes(bytes: &[u8]) {
    for &byte in bytes {
        writec(byte);
    }
}

fn writec(byte: u8) {
    // SAFETY: `hlt #0xF000` issues the semihosting call named by x0 with
    // its parameter in x1. `SYS_WRITEC` reads one byte at the address in
    // x1, which is the live `byte` local. The call writes no guest state.
    unsafe {
        core::arch::asm!(
            "mov x0, {op}",
            "mov x1, {arg}",
            "hlt #0xF000",
            op = in(reg) SYS_WRITEC,
            arg = in(reg) core::ptr::from_ref(&byte),
            out("x0") _,
            out("x1") _,
            options(readonly, nostack, preserves_flags),
        );
    }
}

fn exit_clean() {
    sys_exit(SYS_EXIT, 0);
}

fn exit_with_code(code: usize) {
    sys_exit(SYS_EXIT_EXTENDED, code);
}

/// Requests guest exit with a status code.
///
/// `op` is `SYS_EXIT` or `SYS_EXIT_EXTENDED`: on `AArch64` both take a
/// parameter block holding reason and status.
fn sys_exit(op: usize, status: usize) {
    let params = [APP_EXIT, status];
    // SAFETY: the call reads two words at the address in x1, which is
    // the live `params` array, and writes no guest state. A host that
    // resumes after the call falls through to the caller's park.
    unsafe {
        core::arch::asm!(
            "mov x0, {op}",
            "mov x1, {arg}",
            "hlt #0xF000",
            op = in(reg) op,
            arg = in(reg) params.as_ptr(),
            out("x0") _,
            out("x1") _,
            options(readonly, nostack, preserves_flags),
        );
    }
}
