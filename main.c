#define C_ENTRY __attribute__((section(".text.main")))

C_ENTRY void __main(void) {
    int i;
    char s[] = {'h', 'e', 'l', 'l', 'o', ' ', 'w', 'o', 'r', 'l', 'd'};
    for (i = 0; i < sizeof(s); ++i) {
        __asm__ (
            "int $0x10" : : "a" ((0x0e << 8) | s[i])
        );
    }
    while (1) {
        __asm__ ("hlt");
    };
}
