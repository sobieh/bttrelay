p5_5  equ    0cdh
p5m0  equ    0cah
rb0r0 equ    0
rb0r1 equ    1
rb0r2 equ    2
rb0r3 equ    3
rb0r4 equ    4
rb0r5 equ    5
rb0r6 equ    6
rb0r7 equ    7
rb1r0 equ    8

org    0
    ljmp    reset

set_rx:
    clr     txd
    setb    rxd
    ret

org    0bh
    ljmp    on_timer0

on_timer0:
    push    acc
    push    b
    push    dph
    push    dpl
    push    psw
    mov     psw, #0
    push    rb0r0
    push    rb0r1
    push    rb0r2
    push    rb0r3
    push    rb0r4
    push    rb0r5
    push    rb0r6
    push    rb0r7
    jb      int1, on_timer0_exit
    mov     r7, #32h
    mov     r6, #0
    lcall   delay        ; delay(50)
    jb      int1, on_timer0_exit
    setb    p5_5
    lcall   set_rx
    sjmp    $            ; while(1);
on_timer0_exit:
    pop     rb0r7
    pop     rb0r6
    pop     rb0r5
    pop     rb0r4
    pop     rb0r3
    pop     rb0r2
    pop     rb0r1
    pop     rb0r0
    pop     psw
    pop     dpl
    pop     dph
    pop     b
    pop     acc
    reti

main:
    mov     p5m0, #0ffh
    
    lcall   init
    lcall   init_interrupts
    
main_loop:

    jb      int0, main_loop_on
main_loop_off:
    jnb     p5_5, main_loop_continue
    clr     p5_5        ; turn on 230v
    lcall   set_tx
    ljmp    main_loop_continue
main_loop_on:
    jb      p5_5, main_loop_continue
    setb    p5_5        ; turn off 230v
    lcall   set_rx

main_loop_continue:
    mov     r7, #0b8h   ; delay(3000)
    mov     r6, #0bh
    lcall   delay

    sjmp    main_loop

delay:
    mov     a, r7
    dec     r7
    jnz     delay_0
    dec     r6
delay_0:
    dec     a
    orl     a, r6
    jz      delay_exit
    nop
    nop
    nop
    mov     r5, #0bh
    mov     r4, #0beh
delay_loop:
    djnz    r4, delay_loop
    djnz    r5, delay_loop
    sjmp    delay
delay_exit:
    ret


reset:
    mov     r0, #7fh
    clr     a
memset_loop:
    mov     @r0, a
    djnz    r0, memset_loop
    mov     sp, #8
    ljmp    main

init:
    setb    p5_5        ; clr - default on / setb - default OFF
    clr     rxd
    clr     txd
    setb    int0
    ljmp    set_tx

init_interrupts:
    mov     rb1r0, #1
    setb    it1         ; falling edge of INT1
    setb    ea          ; enable interrupts
    setb    ex1         ; enable INT1 interrupt which is weird as we need timer0 ?!
    ret

set_tx:
    clr     rxd
    setb    txd
    ret

