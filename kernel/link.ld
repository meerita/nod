/* M0 kernel layout: one load image at the start of QEMU `virt` RAM. */

OUTPUT_FORMAT("elf64-littleaarch64")
OUTPUT_ARCH(aarch64)
ENTRY(_start)

M0_RAM_BASE = 0x40000000;
M0_STACK_SIZE = 0x4000;

SECTIONS
{
    . = M0_RAM_BASE;
    .text : {
        *(.text._start)
        *(.text .text.*)
    }
    .rodata : {
        *(.rodata .rodata.*)
    }
    .data : {
        *(.data .data.*)
    }
    .bss : {
        . = ALIGN(16);
        __bss_start = .;
        *(.bss .bss.* COMMON)
        . = ALIGN(16);
        __stack_bottom = .;
        . += M0_STACK_SIZE;
        . = ALIGN(16);
        __stack_top = .;
        __bss_end = .;
    }
    /DISCARD/ : {
        *(.comment .note*)
    }
}
