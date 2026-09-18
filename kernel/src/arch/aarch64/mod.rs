//! Owns `AArch64` early entry state.
//!
//! This module does not own machine composition or console output.

use core::arch::naked_asm;

/// First instruction of the kernel image.
///
/// Requires the M0 entry state: MMU and caches off. Establishes the EL1
/// profile (validates `CurrentEL`, sets SP, masks `DAIF`, zeroes `.bss`)
/// and transfers to the generic entry point. Parks on an EL mismatch.
#[unsafe(no_mangle)]
#[unsafe(naked)]
pub unsafe extern "C" fn _start() -> ! {
    // SAFETY: `_start` runs once per boot with no live stack, so the asm
    // sets SP before any `bl` and uses only x0 and x1. `__stack_top`,
    // `__bss_start`, and `__bss_end` are linker-script symbols bounding
    // writable RAM, and `entry` names the generic entry point, which
    // never returns.
    naked_asm!(
        "mrs x0, CurrentEL",
        // CurrentEL reads 0x4 at EL1.
        "cmp x0, #0x4",
        "b.ne 2f",
        "adrp x0, __stack_top",
        "add x0, x0, :lo12:__stack_top",
        "mov sp, x0",
        "msr daifset, #0xf",
        "adrp x0, __bss_start",
        "add x0, x0, :lo12:__bss_start",
        "adrp x1, __bss_end",
        "add x1, x1, :lo12:__bss_end",
        "1:",
        "cmp x0, x1",
        "b.hs 3f",
        "str xzr, [x0], #8",
        "b 1b",
        "3:",
        "bl {entry}",
        "0: wfe",
        "b 0b",
        "2: wfe",
        "b 2b",
        entry = sym crate::kernel_entry,
    )
}

/// Parks the calling processor.
pub fn park() -> ! {
    loop {
        // SAFETY: `wfe` waits for an event and changes no state the caller
        // depends on; execution resumes at the next instruction.
        unsafe {
            core::arch::asm!("wfe", options(nomem, nostack, preserves_flags));
        }
    }
}
