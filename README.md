# Barebone-i386

A sample project that can load a 16-bit binary that's bigger than 512 bytes.

---

Based on https://github.com/cirosantilli/x86-bare-metal-examples#c-hello-world

## Building

```
mingw32-make
```

---

## entry.asm
### _start
First, the boot sector is copied to **0x600**.
### _loadc
Loads the number of sectors to read into register **AL** from symbol **_\_c_sectors**. \
The current maxmimum amount of sectors for a DSHD 5.25" 1.22 MB Floppy is 15.
### _loadsectors
Calls interrupt routine **INT 13h AH=2**, which reads the sectors and stores them into **ES:BX**, which should be **0x800**.\
The stack is adjusted to symbol **_\_stack_top**. \
Program now enters the c binary at **0x800**.

---

## linker.ld
```c
entry.o(.text)
/* Define MBR Signature here */
FILL(0x0)
. = 512 - 2;
SHORT(0xaa55);
```
Self-explanatory. We load the binary from entry.asm first, then fill the rest of the boot sector with 0 bytes and define the MBR signature at the end.

```c
//main.c:
#define C_ENTRY __attribute__((section(".text.main")))
C_ENTRY void __main(void);

//linker.ld:
*(.text.main)
*(.text)        /* Correct order for .text section */
```
We have to make sure that the main function is _actually_ the main function/entry point of the c binary. Otherwise, other functions could get called ahead of it.

```c
/* Calculate how many sectors section takes up */
__c_sectors = ((__c_end - __c_start) / 512) - 0x600 + 1;
```
Divide the size of the C binary by 512 bytes which is the size of a sector. \
Subtract it by 0x600 (which was the origin address).\
Then add 1 to get the size of the C binary in sectors.

---

### NOTES WITH MINGW ###
* Extraneous sections will get deleted by objcopy. You should do all binary placements and signature placements within the .text section.
