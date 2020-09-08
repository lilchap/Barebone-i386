/* Disk Geometry: 5.25" DSDD 1.2 MB */
/* Heads 2 ; Cylinders 80 ; Sectors per Cylinder 15 ; Sector Size 512*/

ENTRY(_start)
SECTIONS
{
  . = 0x600;
  .text : {
    entry.o(.text)
    /* Define MBR Signature here */
    FILL(0x0)
    . = 512 - 2;
    SHORT(0xaa55);

    /* C Code*/
    __c_start = .; /* Should always be 0x800 */

    *(.text)
    *(.data)
    *(.rodata)
    *(.bss)
    *(COMMON)

    __c_end = .;
    /* Calculate how many sectors section takes up */
    __c_sectors = ((__c_end - __c_start) / 512) - 0x600 + 1;
  }
  /DISCARD/ : {
    *(.eh_frame)
  }
  __stack_bottom = .;
  . = . + 0x1000;
  __stack_top = .;
}
