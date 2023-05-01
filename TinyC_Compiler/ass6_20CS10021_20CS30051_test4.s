	.file	"ass6_20CS10021_20CS30051_test4.c"

#	Allocation of function variables and temporaries on the stack:

#	main
#	t10: -4
#	t11: -8
#	t8: -12
#	t9: -16
#	x: -20
#	max_area
#	a: -4
#	area: -12
#	b: -8
#	side: -16
#	t6: -20
#	t7: -24
#	max_mag
#	ans: -12
#	t0: -16
#	t1: -20
#	t2: -24
#	t3: -28
#	t4: -32
#	t5: -36
#	x: -4
#	y: -8
#	printInt
#	n: -4
#	printStr
#	s: -8
#	readInt
#	eP: -8

	.text
	.globl  max_mag
	.type   max_mag, @function
max_mag:
.LFB0:
	.cfi_startproc
	pushq   %rbp
	.cfi_def_cfa_offset 16
	.cfi_offset 6, -16
	movq    %rsp, %rbp
	.cfi_def_cfa_register 6
	subq    $36, %rsp
	movl    %edi, -4(%rbp)
	movl    %esi, -8(%rbp)
	movl    $0, -16(%rbp)
	movl    -16(%rbp), %eax
	movl    %eax, -12(%rbp)
	movl    $0, -20(%rbp)
	movl    -20(%rbp), %eax
	cmpl    %eax, -4(%rbp)
	jl      .L3
	jmp     .L4
.L3:
	movl    -4(%rbp), %eax
	subl    , %eax
	movl    %eax, -24(%rbp)
	movl    -24(%rbp), %eax
	movl    %eax, -4(%rbp)
	jmp     .L4
.L4:
	movl    $0, -28(%rbp)
	movl    -28(%rbp), %eax
	cmpl    %eax, -8(%rbp)
	jl      .L5
	jmp     .L6
.L5:
	movl    -8(%rbp), %eax
	subl    , %eax
	movl    %eax, -32(%rbp)
	movl    -32(%rbp), %eax
	movl    %eax, -8(%rbp)
	jmp     .L6
.L6:
	movl    -8(%rbp), %eax
	cmpl    %eax, -4(%rbp)
	jg      .L7
	jmp     .L8
	jmp     .L9
.L7:
	jmp     .L10
.L8:
	movl    -8(%rbp), %eax
	movl    %eax, -36(%rbp)
	jmp     .L9
.L10:
	movl    -4(%rbp), %eax
	movl    %eax, -36(%rbp)
	jmp     .L9
.L9:
	movl    -36(%rbp), %eax
	movl    %eax, -12(%rbp)
	movl    -12(%rbp), %eax
.LFE0:
	movq    %rbp, %rsp
	popq    %rbp
	.cfi_def_cfa 7, 8
	ret
	.cfi_endproc
	.size   max_mag, .-max_mag
	.text
	.globl  max_area
	.type   max_area, @function
max_area:
.LFB1:
	.cfi_startproc
	pushq   %rbp
	.cfi_def_cfa_offset 16
	.cfi_offset 6, -16
	movq    %rsp, %rbp
	.cfi_def_cfa_register 6
	subq    $24, %rsp
	movl    %edi, -4(%rbp)
	movl    %esi, -8(%rbp)
	movl    -8(%rbp), %esi
	movl    -4(%rbp), %edi
	call    max_mag
	movl    %eax, -20(%rbp)
	movl    -20(%rbp), %eax
	movl    %eax, -16(%rbp)
	movl    -16(%rbp), %eax
	imull   -16(%rbp), %eax
	movl    %eax, -24(%rbp)
	movl    -24(%rbp), %eax
	movl    %eax, -12(%rbp)
	movl    -12(%rbp), %eax
.LFE1:
	movq    %rbp, %rsp
	popq    %rbp
	.cfi_def_cfa 7, 8
	ret
	.cfi_endproc
	.size   max_area, .-max_area
	.text
	.globl  main
	.type   main, @function
main:
.LFB2:
	.cfi_startproc
	pushq   %rbp
	.cfi_def_cfa_offset 16
	.cfi_offset 6, -16
	movq    %rsp, %rbp
	.cfi_def_cfa_register 6
	subq    $20, %rsp
	movl    $7, -12(%rbp)
	movl    $9, -16(%rbp)
	movl    -16(%rbp), %eax
	subl    , %eax
	movl    %eax, -4(%rbp)
	movl    -4(%rbp), %esi
	movl    -12(%rbp), %edi
	call    max_area
	movl    %eax, -8(%rbp)
	movl    -8(%rbp), %eax
	movl    %eax, -20(%rbp)
.LFE2:
	movq    %rbp, %rsp
	popq    %rbp
	.cfi_def_cfa 7, 8
	ret
	.cfi_endproc
	.size   main, .-main
