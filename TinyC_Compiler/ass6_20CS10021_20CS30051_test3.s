	.file	"ass6_20CS10021_20CS30051_test3.c"

#	Allocation of function variables and temporaries on the stack:

#	fib
#	n: -4
#	t10: -8
#	t11: -12
#	t12: -16
#	t13: -20
#	t14: -24
#	t15: -28
#	t16: -32
#	t17: -36
#	t18: -40
#	t19: -44
#	t20: -48
#	t3: -56
#	t4: -60
#	t5: -64
#	t6: -68
#	t7: -72
#	t8: -76
#	t9: -80
#	main
#	res: -1
#	t21: -5
#	t22: -9
#	t23: -13
#	t24: -17
#	t25: -21
#	t26: -25
#	t27: -29
#	t28: -33
#	t29: -37
#	t30: -41
#	t31: -45
#	t32: -49
#	t33: -53
#	t34: -57
#	t35: -61
#	t36: -65
#	t37: -69
#	t38: -73
#	t39: -81
#	t40: -85
#	t41: -89
#	x: -93
#	printInt
#	n: -4
#	printStr
#	s: -8
#	readInt
#	eP: -8

	.section	.rodata
.LC0:
	.string	"\nValue of input is :"
.LC1:
	.string	"Conditionals checked"
	.globl  c
	.data   
	.type   c, @object
	.size   c, 1
c:
	.byte   118
	.globl  d
	.data   
	.type   d, @object
	.size   d, 1
d:
	.byte   105
	.text
	.globl  fib
	.type   fib, @function
fib:
.LFB0:
	.cfi_startproc
	pushq   %rbp
	.cfi_def_cfa_offset 16
	.cfi_offset 6, -16
	movq    %rsp, %rbp
	.cfi_def_cfa_register 6
	subq    $80, %rsp
	movl    %edi, -4(%rbp)
	movl    %esi, -4(%rbp)
	.globl  fib
	.type   fib, @function
fib:
.LFB0:
	.cfi_startproc
	pushq   %rbp
	.cfi_def_cfa_offset 16
	.cfi_offset 6, -16
	movq    %rsp, %rbp
	.cfi_def_cfa_register 6
	subq    $80, %rsp
	movl    %edi, -4(%rbp)
	movl    %esi, -4(%rbp)
	movq    $.LC0, -56(%rbp)
	movq    -56(%rbp), %rdi
	call    printStr
	movl    %eax, -60(%rbp)
	movl    -4(%rbp), %edi
	call    printInt
	movl    %eax, -64(%rbp)
	movl    $1, -68(%rbp)
	movl    -68(%rbp), %eax
	cmpl    %eax, -4(%rbp)
	jle     .L2
	jmp     .L3
.L2:
	movl    -4(%rbp), %eax
	jmp     .LFE0
	jmp     .LFE0
.L3:
	movl    -4(%rbp), %eax
	imull   $4, %eax
	movl    %eax, -72(%rbp)
	movl    -72(%rbp), %eax
	cltq    
	movl    0(%rbp, %rax, 1), %eax
	movl    %eax, -76(%rbp)
	movl    $1, -80(%rbp)
	movl    -80(%rbp), %eax
	subl    , %eax
	movl    %eax, -8(%rbp)
	movl    -8(%rbp), %eax
	cmpl    %eax, -76(%rbp)
	jne     .L4
	jmp     .L5
.L4:
	movl    -4(%rbp), %eax
	imull   $4, %eax
	movl    %eax, -12(%rbp)
	movl    -12(%rbp), %eax
	cltq    
	movl    0(%rbp, %rax, 1), %eax
	movl    %eax, -16(%rbp)
	movl    -16(%rbp), %eax
	jmp     .LFE0
	jmp     .LFE0
.L5:
	movl    -4(%rbp), %eax
	imull   $4, %eax
	movl    %eax, -20(%rbp)
	movl    $1, -24(%rbp)
	movl    -4(%rbp), %eax
	subl    -24(%rbp), %eax
	movl    %eax, -28(%rbp)
	movl    -28(%rbp), %edi
	call    fib
	movl    %eax, -32(%rbp)
	movl    $2, -36(%rbp)
	movl    -4(%rbp), %eax
	subl    -36(%rbp), %eax
	movl    %eax, -40(%rbp)
	movl    -40(%rbp), %edi
	call    fib
	movl    %eax, -44(%rbp)
	movl    -32(%rbp), %eax
	addl    -44(%rbp), %eax
	movl    %eax, -48(%rbp)
	movl    -20(%rbp), %eax
	cltq    
	movl    -48(%rbp), %ebx
	movl    %ebx, 0(%rbp, %rax, 1)
	movl    -48(%rbp), %eax
.LFE0:
	movq    %rbp, %rsp
	popq    %rbp
	.cfi_def_cfa 7, 8
	ret
	.cfi_endproc
	.size   fib, .-fib
	.text
	.globl  main
	.type   main, @function
main:
.LFB1:
	.cfi_startproc
	pushq   %rbp
	.cfi_def_cfa_offset 16
	.cfi_offset 6, -16
	movq    %rsp, %rbp
	.cfi_def_cfa_register 6
	subq    $93, %rsp
	movl    $0, -5(%rbp)
	movl    -5(%rbp), %eax
	movl    %eax, i
.L8:
	movl    $50, -9(%rbp)
	movl    -9(%rbp), %eax
	cmpl    %eax, i
	jl      .L6
	jmp     .L7
.L9:
	movl    i, %eax
	movl    %eax, -13(%rbp)
	incl    i
	jmp     .L8
.L6:
	movl    i, %eax
	imull   $4, %eax
	movl    %eax, -17(%rbp)
	movl    $1, -21(%rbp)
	movl    -21(%rbp), %eax
	subl    , %eax
	movl    %eax, -25(%rbp)
	movl    -17(%rbp), %eax
	cltq    
	movl    -25(%rbp), %ebx
	movl    %ebx, 0(%rbp, %rax, 1)
	jmp     .L9
.L7:
	movl    $0, -29(%rbp)
	movl    -29(%rbp), %eax
	imull   $4, %eax
	movl    %eax, -33(%rbp)
	movl    $0, -37(%rbp)
	movl    -33(%rbp), %eax
	cltq    
	movl    -37(%rbp), %ebx
	movl    %ebx, 0(%rbp, %rax, 1)
	movl    $1, -41(%rbp)
	movl    -41(%rbp), %eax
	imull   $4, %eax
	movl    %eax, -45(%rbp)
	movl    $0, -49(%rbp)
	movl    -45(%rbp), %eax
	cltq    
	movl    -49(%rbp), %ebx
	movl    %ebx, 0(%rbp, %rax, 1)
	movl    $32, -53(%rbp)
	movl    -53(%rbp), %edi
	call    fib
	movl    %eax, -57(%rbp)
	movl    -57(%rbp), %eax
	movl    %eax, -93(%rbp)
	movl    $2, -61(%rbp)
	movl    -93(%rbp), %eax
	cdq     
	idivl   -61(%rbp)
	movl    %edx, -65(%rbp)
	movl    $1, -69(%rbp)
	movl    -69(%rbp), %eax
	cmpl    %eax, -65(%rbp)
	je      .L10
	jmp     .L11
.L10:
	movl    $100, -73(%rbp)
	movl    -73(%rbp), %eax
	cmpl    %eax, -93(%rbp)
	jg      .L12
	jmp     .L11
.L12:
	movb    c, %al
	movb    %al, -1(%rbp)
	jmp     .L13
.L11:
	movb    d, %al
	movb    %al, -1(%rbp)
.L13:
	movq    $.LC1, -81(%rbp)
	movq    -81(%rbp), %rdi
	call    printStr
	movl    %eax, -85(%rbp)
	movl    $0, -89(%rbp)
	movl    -89(%rbp), %eax
.LFE1:
	movq    %rbp, %rsp
	popq    %rbp
	.cfi_def_cfa 7, 8
	ret
	.cfi_endproc
	.size   main, .-main
