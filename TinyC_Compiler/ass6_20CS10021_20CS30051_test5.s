	.file	"ass6_20CS10021_20CS30051_test5.c"

#	Allocation of function variables and temporaries on the stack:

#	main
#	a: -4
#	b: -8
#	c: -12
#	d: -16
#	t0: -20
#	t1: -24
#	t10: -32
#	t11: -36
#	t12: -40
#	t13: -48
#	t14: -52
#	t15: -56
#	t16: -60
#	t17: -68
#	t18: -72
#	t19: -76
#	t2: -80
#	t20: -84
#	t21: -92
#	t22: -96
#	t23: -100
#	t24: -104
#	t25: -112
#	t26: -116
#	t27: -120
#	t28: -124
#	t29: -132
#	t3: -136
#	t30: -140
#	t31: -144
#	t32: -152
#	t33: -156
#	t4: -164
#	t5: -168
#	t6: -172
#	t7: -180
#	t8: -184
#	t9: -188
#	printInt
#	n: -4
#	printStr
#	s: -8
#	readInt
#	eP: -8

	.section	.rodata
.LC0:
	.string	"Values of data is:"
.LC1:
	.string	" "
.LC2:
	.string	" "
.LC3:
	.string	" "
.LC4:
	.string	"Value of c is:"
.LC5:
	.string	"Value of b is:"
.LC6:
	.string	"Value of a is:"
.LC7:
	.string	"Value of a is:"
.LC8:
	.string	"\na > b"
	.text
	.globl  main
	.type   main, @function
main:
.LFB0:
	.cfi_startproc
	pushq   %rbp
	.cfi_def_cfa_offset 16
	.cfi_offset 6, -16
	movq    %rsp, %rbp
	.cfi_def_cfa_register 6
	subq    $188, %rsp
	movl    $0, -20(%rbp)
	movl    -20(%rbp), %eax
	movl    %eax, -4(%rbp)
	movl    $1, -24(%rbp)
	movl    -24(%rbp), %eax
	movl    %eax, -8(%rbp)
	movl    $2, -80(%rbp)
	movl    -80(%rbp), %eax
	movl    %eax, -12(%rbp)
	movl    $3, -136(%rbp)
	movl    -136(%rbp), %eax
	movl    %eax, -16(%rbp)
	movq    $.LC0, -164(%rbp)
	movq    -164(%rbp), %rdi
	call    printStr
	movl    %eax, -168(%rbp)
	movl    -4(%rbp), %edi
	call    printInt
	movl    %eax, -172(%rbp)
	movq    $.LC1, -180(%rbp)
	movq    -180(%rbp), %rdi
	call    printStr
	movl    %eax, -184(%rbp)
	movl    -8(%rbp), %edi
	call    printStr
	movl    %eax, -188(%rbp)
	movq    $.LC2, -32(%rbp)
	movq    -32(%rbp), %rdi
	call    printStr
	movl    %eax, -36(%rbp)
	movl    -12(%rbp), %edi
	call    printInt
	movl    %eax, -40(%rbp)
	movq    $.LC3, -48(%rbp)
	movq    -48(%rbp), %rdi
	call    printStr
	movl    %eax, -52(%rbp)
	movl    -16(%rbp), %edi
	call    printStr
	movl    %eax, -56(%rbp)
	movl    -8(%rbp), %eax
	addl    -16(%rbp), %eax
	movl    %eax, -60(%rbp)
	movl    -60(%rbp), %eax
	movl    %eax, -12(%rbp)
	movq    $.LC4, -68(%rbp)
	movq    -68(%rbp), %rdi
	call    printStr
	movl    %eax, -72(%rbp)
	movl    -4(%rbp), %edi
	call    printInt
	movl    %eax, -76(%rbp)
	movl    -12(%rbp), %eax
	subl    -16(%rbp), %eax
	movl    %eax, -84(%rbp)
	movl    -84(%rbp), %eax
	movl    %eax, -8(%rbp)
	movq    $.LC5, -92(%rbp)
	movq    -92(%rbp), %rdi
	call    printStr
	movl    %eax, -96(%rbp)
	movl    -4(%rbp), %edi
	call    printInt
	movl    %eax, -100(%rbp)
	movl    -8(%rbp), %eax
	imull   -12(%rbp), %eax
	movl    %eax, -104(%rbp)
	movl    -104(%rbp), %eax
	movl    %eax, -4(%rbp)
	movq    $.LC6, -112(%rbp)
	movq    -112(%rbp), %rdi
	call    printStr
	movl    %eax, -116(%rbp)
	movl    -4(%rbp), %edi
	call    printInt
	movl    %eax, -120(%rbp)
	movl    -4(%rbp), %eax
	movl    %eax, -124(%rbp)
	incl    -4(%rbp)
	movq    $.LC7, -132(%rbp)
	movq    -132(%rbp), %rdi
	call    printStr
	movl    %eax, -140(%rbp)
	movl    -4(%rbp), %edi
	call    printInt
	movl    %eax, -144(%rbp)
	movl    -8(%rbp), %eax
	cmpl    %eax, -4(%rbp)
	jg      .L0
	jmp     .L0
	movq    $.LC8, -152(%rbp)
	movq    -152(%rbp), %rdi
	call    printStr
	movl    %eax, -156(%rbp)
