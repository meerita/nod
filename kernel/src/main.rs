//! Nod kernel entry point.

#![no_std]
#![no_main]
// The kernel is the one crate that touches hardware and architecture
// mechanisms, which `15-unsafe.md` permits. Cargo rejects a manifest that
// inherits the workspace lints and overrides one of them, so the exception
// lives here. Every other crate keeps the workspace default.
#![allow(unsafe_code)]

use core::panic::PanicInfo;

/// Entry point reached from the reset vector.
#[unsafe(no_mangle)]
pub extern "C" fn _start() -> ! {
    halt()
}

/// Stops the calling processor.
fn halt() -> ! {
    loop {
        // SAFETY: `wfe` waits for an event and changes no architectural state
        // that the caller depends on. The processor resumes at the next
        // instruction, which returns to this loop.
        unsafe {
            core::arch::asm!("wfe", options(nomem, nostack, preserves_flags));
        }
    }
}

#[panic_handler]
fn panic(_info: &PanicInfo) -> ! {
    halt()
}
