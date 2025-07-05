.section __TEXT,__text
.globl _start
.align 2
_start:
    // 获取 msg 地址（合法方式：adrp + add）
    adrp    x1, msg@PAGE
    add     x1, x1, msg@PAGEOFF

    mov     x0, #1              // stdout
    mov     x2, #14             // 字符串长度
    mov     x16, #4             // syscall write
    svc     #0x80

    mov     x0, #0              // 退出码 0
    mov     x16, #1             // syscall exit
    svc     #0x80

.section __TEXT,__data
.align 3
msg:
    .asciz "Hello, World!\n"
