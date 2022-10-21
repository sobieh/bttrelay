p5_5    equ     0cdh
p5m0    equ     0cah

org	0
	ljmp	reset

set_rx:
	setb	rxd
	clr		txd
	ret

org	0bh
	ljmp	on_timer0

on_timer0:
	push	acc
	push	b
	push	dph
	push	dpl
	push	psw
	mov		psw, #0
	push	rb0r0
	push	rb0r1
	push	rb0r2
	push	rb0r3
	push	rb0r4
	push	rb0r5
	push	rb0r6
	push	rb0r7
	jb		int1, on_timer0_exit
	mov		r7, #32h
	mov		r6, #0
	lcall	delay        ; delay(50)
	jb		int1, on_timer0_exit
	setb	p5_5
	lcall	set_rx
	sjmp	$            ; while(1);
on_timer0_exit:
	pop	rb0r7
	pop	rb0r6
	pop	rb0r5
	pop	rb0r4
	pop	rb0r3
	pop	rb0r2
	pop	rb0r1
	pop	rb0r0
	pop	psw
	pop	dpl
	pop	dph
	pop	b
	pop	acc
	reti

main:
	mov		p5m0, #0ffh
	
	lcall	init
	lcall	init_interrupts
	
	mov		r7, #40h ; 7500
	mov		r6, #1fh
	lcall	delay

main_loop:
	jnb		int0, main_loop
	mov		r7, #4ch
	mov		r6, #1dh
	lcall	delay
	jnb		int0, main_loop

	setb	p5_5
	lcall	set_rx
	sjmp	main_loop

delay:
	mov		a, r7
	dec		r7
	jnz		delay_0
	dec		r6
delay_0:
	dec		a
	orl		a, r6
	jz		delay_exit
	nop
	nop
	nop
	mov		r5, #0bh
	mov		r4, #0beh
delay_loop:
	djnz	r4, delay_loop
	djnz	r5, delay_loop
	sjmp	delay
delay_exit:
	ret


reset:
	mov		r0, #7fh
	clr		a
memset_loop:
	mov		@r0, a
	djnz	r0, memset_loop
	mov		sp, #8
	ljmp	main

init:
	clr		p5_5
	clr		rxd
	clr		txd
	setb	int0
	ljmp	set_tx

init_interrupts:
	mov		rb1r0, #1
	setb	it1			; falling edge of INT1
	setb	ea			; enable interrupts
	setb	ex1			; enable INT1 interrupt
	ret

set_tx:
	clr		rxd
	setb	txd
	ret

rb0r0	equ	0
rb0r1	equ	1
rb0r2	equ	2
rb0r3	equ	3
rb0r4	equ	4
rb0r5	equ	5
rb0r6	equ	6
rb0r7	equ	7
rb1r0	equ	8
