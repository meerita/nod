//! Owns the `qemu-virt` machine composition.
//!
//! This module declares the EL1 profile: the image executes at EL1 under
//! the QEMU `virt` default options. It does not own architecture entry
//! state or device programming.

/// Boots the M0 kernel on `qemu-virt`.
///
/// Entry contract: called once at EL1 with SP set and `DAIF` masked.
/// Halts.
pub fn boot() -> ! {
    crate::arch::aarch64::park()
}
