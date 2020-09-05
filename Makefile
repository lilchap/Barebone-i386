# gcc (MinGW.org GCC Build-20200227-1) 9.2.0
# -Qn = remove that weird .rdata string

link: entry.o main.o
	ld -Map output.map -m i386pe -o main.exe -T linker.ld entry.o main.o
	objcopy -O binary main.exe main.img

entry.o: entry.asm
	nasm -f elf32 entry.asm -o entry.o

main.o: main.c
	gcc -c -ggdb3 -m16 -ffreestanding -fno-PIE -nostartfiles -nostdlib -Qn -std=c99 main.c -o main.o

.PHONY: clean
clean:
	del *.map
	del *.o

.PHONY: rebuild
rebuild: clean
	$(MAKE)