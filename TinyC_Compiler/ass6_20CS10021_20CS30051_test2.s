	.file	"ass6_20CS10021_20CS30051_test2.c"

#	Allocation of function variables and temporaries on the stack:

#	func
#	a: -8
#	t0: -16
#	t1: -20
#	t2: -24
#	t3: -32
#	t4: -36
#	x: -12
#	printInt
#	n: -4
#	printStr
#	s: -8
#	readInt
#	eP: -8

	.section	.rodata
.LC0:
	.string	"New value is :"
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
	movl    %esi, -12(%rbp)
	movq    -8(%rbp), %rax
	movl    (%rax), %eax
	movl    %eax, -16(%rbp)
	movq    -8(%rbp), %rax
	movl    (%rax), %eax
	movl    %eax, -20(%rbp)
	movl    -20(%rbp), %eax
	imull   -12(%rbp), %eax
	movl    %eax, -24(%rbp)
	movl    -24(%rbp), %eax
	movq    -16(%rbp), %rbx
	movl    %eax, (%rbx)
	movq    $.LC0, -32(%rbp)
	movq    -32(%rbp), %rdi
	call    printStr
	movl    %eax, -36(%rbp)
