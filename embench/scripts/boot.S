.section .text.start
.global _start

_start:
    # Set up a minimal stack
    li sp, 0x80001000
    
    # Jump to main
    call main
    
    # Exit simulation (QEMU will terminate on this)
    li a0, 0
    li a7, 93  # exit syscall
    ecall

.section .text
.global exit
exit:
    # Exit with status code in a0
    li a7, 93
    ecall