MEMORY {
    ram : ORIGIN = 0x80000000, LENGTH = 128M
}

SECTIONS {
    .text 0x80000000 : {
        *(.text.start)
        *(.text*)
    } > ram
    
    .data : {
        *(.data*)
    } > ram
    
    .bss : {
        *(.bss*)
    } > ram
}