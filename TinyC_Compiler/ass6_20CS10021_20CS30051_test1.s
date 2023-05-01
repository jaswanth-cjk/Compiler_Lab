	.file	"ass6_20CS10021_20CS30051_test1.c"

#	Allocation of function variables and temporaries on the stack:

#	func
#	a: -8
#	t0: -16
#	t1: -20
#	t2: -24
#	t3: -28
#	t4: -32
#	t5: -36
#	main
#	a: -80
#	i: -84
#	t10: -88
#	t11: -92
#	t12: -100
#	t7: -104
#	t8: -108
#	t9: -112
#	x: -120
#	printInt
#	n: -4
#	printStr
#	s: -8
#	readInt
#	eP: -8
#	strPrint
#	s: -8
#	t6: -12

	.section	.rodata
.LC0:
	.string	"\nValue of a[2] is :"
.LC1:
	.string	"Printing has started."
	.text
	.globl  func
	.type   func, @function
func:
.LFB0:
	.cfi_startproc
	pushq   %rbp
	.cfi_def_cfa_offset 16
	.cfi_offset 6, -16
	movq    %rsp, %rbp
	.cfi_def_cfa_register 6
	subq    $36, %rsp
	movq    %rdi, -8(%rbp)
	movq    $.LC0, -16(%rbp)
	movq    -16(%rbp), %rdi
	call    printStr
	movl    %eax, -20(%rbp)
	movl    $2, -24(%rbp)
	movl    -24(%rbp), %eax
	imull   $4, %eax
	movl    %eax, -28(%rbp)
	movl    -28(%rbp), %eax
	cltq    
	addq    -8(%rbp), %rax
	movl    (%rax), %eax
	movl    %eax, -32(%rbp)
	movl    -32(%rbp), %edi
	call    printInt
	movl    %eax, -36(%rbp)
.LFE0:
	movq    %rbp, %rsp
	popq    %rbp
	.cfi_def_cfa 7, 8
	ret
	.cfi_endproc
	.size   func, .-func
	.text
	.globl  strPrint
	.type   strPrint, @function
strPrint:
.LFB1:
	.cfi_startproc
	pushq   %rbp
	.cfi_def_cfa_offset 16
	.cfi_offset 6, -16
	movq    %rsp, %rbp
	.cfi_def_cfa_register 6
	subq    $12, %rsp
	movq    %rdi, -8(%rbp)
	movq    -8(%rbp), %rdi
	call    printStr
	movl    %eax, -12(%rbp)
.LFE1:
	movq    %rbp, %rsp
	popq    %rbp
	.cfi_def_cfa 7, 8
	ret
	.cfi_endproc
	.size   strPrint, .-strPrint
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
	subq    $120, %rsp
	movl    $20, -104(%rbp)
	movl    $0, -108(%rbp)
	movl    -108(%rbp), %eax
	movl    %eax, -84(%rbp)
.L5:
	movl    $20, -112(%rbp)
	movl    -112(%rbp), %eax
	cmpl    %eax, -84(%rbp)
	jl      .L3
	jmp     .L4
.L6:
	movl    -84(%rbp), %eax
	movl    %eax, -88(%rbp)
	incl    -84(%rbp)
	jmp     .L5
.L3:
	movl    -84(%rbp), %eax
	imull   $4, %eax
	movl    %eax, -92(%rbp)
	movl    -92(%rbp), %eax
	cltq    
	movl    -84(%rbp), %ebx
	movl    %ebx, -80(%rbp, %rax, 1)
	jmp     .L6
.L4:
	movq    $.LC1, -100(%rbp)
	movq    -100(%rbp), %rax
	movq    %rax, -120(%rbp)
	movq    -120(%rbp), %rdi
	call    strPrint
	leaq    -80(%rbp), %rdi
	call    func
.LFE2:
	movq    %rbp, %rsp
	popq    %rbp
	.cfi_def_cfa 7, 8
	ret
	.cfi_endproc
	.size   main, .-main
