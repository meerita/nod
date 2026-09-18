//! Nod kernel entry point.

#![no_std]
#![no_main]
// The kernel is the one crate that touches hardware and architecture
// mechanisms, which `15-unsafe.md` permits. Cargo rejects a manifest that
// inherits the workspace lints and overrides one of them, so the exception
// lives here. Every other crate keeps the workspace default.
#![allow(unsafe_code)]

mod arch;
mod machine;

use core::panic::PanicInfo;

/// Generic entry reached from architecture early entry.
pub(crate) fn kernel_entry() -> ! {
    crate::machine::qemu_virt::boot()
}

#[panic_handler]
fn panic(_info: &PanicInfo) -> ! {
    crate::machine::qemu_virt::panic()
}
