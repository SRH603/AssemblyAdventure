// ------------------------------------------------------------------------
//  adventure.s  –  极简文本冒险 (Apple Silicon / macOS ARM64)
//  assemble :  as    -arch arm64 adventure.s -o adventure.o
//  link     :  clang -arch arm64 -nostartfiles -Wl,-e,_start adventure.o -o adventure
//  run      :  ./adventure
// ------------------------------------------------------------------------

        .section __TEXT,__text,regular,pure_instructions
        .globl  _start
        .align  2

// ---------------- 入口 ----------------
_start:
        // ---- 输出提示 ----
        mov     x0, #1                          // stdout (fd = 1)
        adrp    x1, prompt@PAGE
        add     x1, x1, prompt@PAGEOFF
        mov     x2, #76                         // bytes to write
        mov     x16, #4                         // sys_write
        svc     #0x80

        // ---- 读取用户输入 ----
        mov     x0, #0                          // stdin
        adrp    x1, inputbuf@PAGE
        add     x1, x1, inputbuf@PAGEOFF
        mov     x2, #2                          // 1 字符 + 回车
        mov     x16, #3                         // sys_read
        svc     #0x80

        // ---- 取首字符并分支 ----
        adrp    x1, inputbuf@PAGE
        add     x1, x1, inputbuf@PAGEOFF
        ldrb    w3, [x1]                        // w3 = input[0]

        // if 'l' | 'L'
        mov     w4, #'l'
        cmp     w3, w4
        beq     choose_left
        mov     w4, #'L'
        cmp     w3, w4
        beq     choose_left

        // if 'r' | 'R'
        mov     w4, #'r'
        cmp     w3, w4
        beq     choose_right
        mov     w4, #'R'
        cmp     w3, w4
        beq     choose_right

invalid_choice:                                 // fall-through: 其他输入
        mov     x0, #1
        adrp    x1, invalid_msg@PAGE
        add     x1, x1, invalid_msg@PAGEOFF
        mov     x2, #16
        mov     x16, #4
        svc     #0x80
        b       exit_game

choose_left:
        mov     x0, #1
        adrp    x1, left_msg@PAGE
        add     x1, x1, left_msg@PAGEOFF
        mov     x2, #46
        mov     x16, #4
        svc     #0x80
        b       exit_game

choose_right:
        mov     x0, #1
        adrp    x1, right_msg@PAGE
        add     x1, x1, right_msg@PAGEOFF
        mov     x2, #49
        mov     x16, #4
        svc     #0x80

exit_game:
        mov     x0, #0                          // status = 0
        mov     x16, #1                         // sys_exit
        svc     #0x80

// ---------------- 数据段 ----------------
        .section __DATA,__data
prompt:
        .asciz  "You are in a dark cave.\nGo left (l) or right (r)? Press enter after choice:\n"

left_msg:
        .asciz  "You go left and a monster appears! Game over.\n"

right_msg:
        .asciz  "You go right and find a treasure chest! You win!\n"

invalid_msg:
        .asciz  "Invalid choice.\n"

// ---------------- BSS 段 -----------------
        .section __BSS,__bss
        .align  3
inputbuf:
        .skip   2                               // 2 字节缓冲