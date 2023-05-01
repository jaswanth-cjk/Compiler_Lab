#Name: Chukka Jaswanth Kumar
#Roll No: 20CS10021
	
	
	.file	"Ass1.c"                                               # source file name    
	.text                                                          # start of text segment (executable code)
	.section	.rodata                                        #read only data section
	.align 8                                                      #align with 8 byte boundary
.LC0:                                                                 #Label of f-string 1st printf  
	.string	"Enter the string (all lowrer case): "        
.LC1:
	.string	"%s"                                            #Label of f-string scanf
.LC2:                                                                  #Label of f-string 2nd printf
	.string	"Length of the string: %d\n"           
	.align 8                                                       #align with 8 byte boundary
.LC3:                                                                 #Label of f-string 3rd printf 
	.string	"The string in descending order: %s\n"     
	.text                                                          #code starts

	.globl	main                                                   #main is global name

	.type	main, @function                                        #main is a function 
main:                                                                 #main function starts

.LFB0:
	.cfi_startproc                           # call frame information
	endbr64                                  # terminate indirect branch in 64 bit
	pushq	%rbp                             #save the old base pointer
	.cfi_def_cfa_offset 16                   # Set CFA to use offset of 16
	.cfi_offset 6, -16                       # Set the rule to set register 6 at offset of -16 from CFI
	movq	%rsp, %rbp                       # rsp->rbp set new stack base pointer
	.cfi_def_cfa_register 6                  # change CFA rule to use offset of 6
	subq	$80, %rsp                        # 80->rsp space for allocating arrays and variables
	movq	%fs:40, %rax                     # segment addressing 
	movq	%rax, -8(%rbp)                   # rax->rbp-8
	xorl	%eax, %eax                       # clear eax

	# printf("Enter the string (all lower case): ");  
	leaq	.LC0(%rip), %rdi                 # load address of .LC0(%rip) int0 %rdi 
	movl	$0, %eax                         # initialize the value of register to 0 
	call	printf@PLT                       # call printf function

	# scanf("%s", str);
	leaq	-64(%rbp), %rax                  # load address (rbp - 64) -> rax
	movq	%rax, %rsi                       # copy the address of the local array to %rsi
	leaq	.LC1(%rip), %rdi                 # load address of .LC1(%rip) -> %rdi
	movl	$0, %eax                         #initialize the value of register to 0 
	call	__isoc99_scanf@PLT               # calling the scanf function  

	# len = length(str); 
	leaq	-64(%rbp), %rax                  # load address of (rbp - 64) -> rax 
	movq	%rax, %rdi                       # copy the data of the local variable to %rdi
	call	length                           # calling the length function 
	movl	%eax, -68(%rbp)                  # store the value of the register in the local array
	movl	-68(%rbp), %eax                  # take the value of the register from the local array
	movl	%eax, %esi                       # copy the data from %eax -> %esi

	# printf("Length of the string: %d\n", len);

	leaq	.LC2(%rip), %rdi                 # load address of .LC2(%rip) into %rdi
	movl	$0, %eax                         # initialize the value of the register to 0
	call	printf@PLT                       # calling the printf function 

        # sort(str, len, dest)
	leaq	-32(%rbp), %rdx                   #load address of -32(%rbp) into %rdx
	movl	-68(%rbp), %ecx                   # copy  long from -68(%rbp) to %ecx	   
	leaq	-64(%rbp), %rax                   # load address of -64(%rbp) into %rdx
	movl	%ecx, %esi                        #copy the data from %eax -> %esi
	movq	%rax, %rdi                        # copy the address of the local array to %rdi
	call	sort                              # calling the sort function

	# printf("The string in descending order: %s\n", dest);
	leaq	-32(%rbp), %rax                  # load address of -32(%rbp) into %rax 
	movq	%rax, %rsi                       # copy the address of the local array to %rdi
	leaq	.LC3(%rip), %rdi                 # load address of .LC3(%rip) into %rdi
	movl	$0, %eax                         # initialize the value of the register to 0
	call	printf@PLT                       # calling the printf function 
	movl	$0, %eax                         # initialize the value of the register to 0
	movq	-8(%rbp), %rcx                   # move the value of the register %rbp-8 to %rcx
	xorq	%fs:40, %rcx  
	je	.L3                              # If equal jum to .L3 
	call	__stack_chk_fail@PLT             # calling the stack_chk_fail function


.L3:                                              # Start of .L3 
	leave                                     # Copy ebp to esp and then restore ebp to old state
	.cfi_def_cfa 7, 8                         # set content of register 7 and 8 to CFA
	ret                                       # return from the function
	.cfi_endproc                              #ter minate the CFI frame
.LFE0:
	.size	main, .-main                      # Size of main function 
	.globl	length                            # Defines the global function that is length 
	.type	length, @function                 # Define type of length ,  which  is function 

length:                                          # Start of length function 
.LFB1:                                           # Start of .LFB1 
	.cfi_startproc                           # initialize internal structures and emit initial CFI
	endbr64                                  # terminate indirect branch in 64 bit
	pushq	%rbp                             # Store the old base pointer 
	.cfi_def_cfa_offset 16                   # Set CFA to use offset of 16
	.cfi_offset 6, -16                       # Set rule to set register 6 at offset of -16 from CFI
	movq	%rsp, %rbp                       # rsp --> rbp set new stack base pointer 
	.cfi_def_cfa_register 6                  # change CFA rule to use offset of 6

	# int i 
	movq	%rdi, -24(%rbp)                  #  copy %rdi to -24( %rbp)

	# for (i = 0; str[i] != '\0'; i++) 
	movl	$0, -4(%rbp)                     # intialising i counter to 0
	jmp	.L5                              # Jump to .L5 # Go to  the for conditional loop 

.L6:                                            # start of .L6
	addl	$1, -4(%rbp)                    # ( rbp - 4) --> ( rbp - 4) + 1 , that is add 1 to i , i++
.L5:                                           # Start of .L5
	movl	-4(%rbp), %eax                  # put value of i ( %rbp - 4 )in  %eax
	movslq	%eax, %rdx                      # eax -> rdx, 32 bits to 64 bits  
	movq	-24(%rbp), %rax                 # -24( rdx) --> %rax , copy data
	addq	%rdx, %rax                      # addition , %rax = %rax + %rdx	
	movzbl	(%rax), %eax                    #  move the value of the register %rax to %eax
	testb	%al, %al                        # test the value of the register if it is 0
	jne	.L6                             # If not equal jum to .L6

	movl	-4(%rbp), %eax                 # get the value of the register from the local array
	popq	%rbp                           # pop the base pointer 
	.cfi_def_cfa 7, 8                      # set content of register 7 and 8 to CFA
	ret                                    # return from the function length
	.cfi_endproc                           # Terminate the CFI frame 

.LFE1:                                         # Start of .LFE1
	.size	length, .-length               # Size of function length 
	.globl	sort                           # Define global function that is sort 
	.type	sort, @function                # Define type of sort , that is function 


sort:                                         # sort function starts
.LFB2:                                        # Start of .LFB2
	.cfi_startproc                         # initialize internal structures and emit initial CFI
	endbr64                                # terminate indirect branch in 64 bit
	pushq	%rbp                           # Store old base pointer
	.cfi_def_cfa_offset 16                 # Set CFI to use offset of 16
	.cfi_offset 6, -16                     # Set rule to set register 6 at offset of -16 from CFI
	movq	%rsp, %rbp                     # rbp <-- rsp set new stack base pointer
	.cfi_def_cfa_register 6                # change CFA rule to use offset of 6
	subq	$48, %rsp                        # 48 -> rsp space for allocating local variables of the function
	movq	%rdi, -24(%rbp)                # 1st argument,rdi -> rbp-24,  str -> rbp-24
	movl	%esi, -28(%rbp)               # 2nd argument, esi -> rbp-28, len -> rbp-28
	movq	%rdx, -40(%rbp)               # 3rd argument, rbp-40,dest -> rbp-40

	# for (i = 0; i < len; i++)
	movl	$0, -8(%rbp)                  # 0 -> rbp-8, i =  0 
	jmp	.L9                           # jump to .L9
		                              # go to the for loop conditional check
.L13:                                        # Start of L13 
        # for (i = 0; i < len; i++) [loop body]
	# for (j = 0; j < len; j++)
	movl	$0, -4(%rbp)                  #   0 -> rbp-4, assign 0 to j (j=0)	
	jmp	.L10                          # jump to .L10 i.e. go to the for loop conditional check										
.L12:                                        # Start of .L12 
        # if (str[i] < str[j])
	movl	-8(%rbp), %eax                 # rbp-8 -> eax, i -> eax 
	movslq	%eax, %rdx                     # eax -> rdx, 32 bits to 64 bits
	movq	-24(%rbp), %rax                # rbp-24 -> rax, str -> rax
	addq	%rdx, %rax                     # rcx+rax -> rax, j + str = str[j] -> rax	
	movzbl	(%rax), %edx                   # move the value of the register %rax to %eax
	movl	-4(%rbp), %eax                 # rbp-4 -> eax, j -> eax
	movslq	%eax, %rcx                     # eax -> rcx, 32 bits to 64 bits
	movq	-24(%rbp), %rax                # rbp-24 -> rax, str -> rax	
	addq	%rcx, %rax                     # rcx+rax -> rax
	movzbl	(%rax), %eax                   # move the value of the register %rax to %eax
	cmpb	%al, %dl                       # compare the value of the register %al to %dl	
	jge	.L11                           # if greater than or equal jump to .L11

	# temp = str[i]
	movl	-8(%rbp), %eax                  # rbp-8 -> eax, i -> eax
	movslq	%eax, %rdx                      # eax -> rdx, 32 bits to 64 bits	
	movq	-24(%rbp), %rax                 # rbp-24 -> rax, str -> rax	
	addq	%rdx, %rax                      # rdx+rax -> rax, i + str = str[i] -> rax
	movzbl	(%rax), %eax                   # move the value of the register %rax to %eax
	movb	%al, -9(%rbp)                  # move the value of the register %al to the rbp-9

	# str[i] = str[j]
	movl	-4(%rbp), %eax                 # str[i] = str[j] , rbp-4 -> eax, j -> eax
	movslq	%eax, %rdx                     # eax -> rdx, 32 bits to 64 bits
	movq	-24(%rbp), %rax                # rbp-24 -> rax, str -> rax	
	addq	%rdx, %rax                     # rdx+rax -> rax, i + str = str[i] -> rax	
	movl	-8(%rbp), %edx                 # rbp-8 -> edx, i -> edx	
	movslq	%edx, %rcx                     # edx -> rcx, 32 bits to 64 bits
	movq	-24(%rbp), %rdx                # rbp-24 -> rdx, str -> rdx	
	addq	%rcx, %rdx                     # rcx+rdx -> rdx, j + str = str[j] -> rdx	
	movzbl	(%rax), %eax                   # move the value of the register %rax to %eax	
	movb	%al, (%rdx)                    # move the value of the register %al to %rdx, ( str[i]=str[j] )


	# str[j] = temp 
	movl	-4(%rbp), %eax                   #  rbp-4 -> eax, j -> eax
	movslq	%eax, %rdx                       # eax -> rdx, 32 bits to 64 bits	 
	movq	-24(%rbp), %rax                  # rbp-24 -> rax, str -> rax		
	addq	%rax, %rdx                       # rax+rdx -> rdx, j + str = str[j] -> rdx		
	movzbl	-9(%rbp), %eax                   # move the value of the register -9(%rbp) to %eax	
	movb	%al, (%rdx)                      # move the value of the register to the local array

.L11:                                           # Start of .L11 
	addl	$1, -4(%rbp)                     # (rbp-4)+1 -> rbp-4, j+1 -> j (j++)


.L10:                                           # Start of .L10 
	movl	-4(%rbp), %eax                  # rbp-4 -> eax, j -> eax
	cmpl	-28(%rbp), %eax                 # logical comparison between len and j	
	jl	.L12                            # If less than jump to .L12  ( j < len ) 
	addl	$1, -8(%rbp)                    # (rbp-8)+1 -> rbp-8, i+1 -> i (i++) 


.L9:                                             # Start of .L9 
	movl	-8(%rbp), %eax                   # rbp-8 -> eax, i -> eax	
	cmpl	-28(%rbp), %eax                  # logical comparison between len and i	
	jl	.L13                             # if less than jump to .L13(i<len)	
	movq	-40(%rbp), %rdx                  # rbp-40 -> rdx, dest -> rdx	
	movl	-28(%rbp), %ecx                  # rbp-28 -> ecx, len -> ecx	
	movq	-24(%rbp), %rax                  # rbp-24 -> rax, str -> rax	
	movl	%ecx, %esi                       # move the value of the register %ecx to %esi	
	movq	%rax, %rdi                       # move the value of the register %rax to %rdi
	call	reverse                          # call the function reverse	
	nop
	leave                                    # Copy EBP to ESP and then restore EBP to old state	
	.cfi_def_cfa 7, 8                        # set content of register 7 and 8 to CFA	 
	ret                                      # return from the function
	.cfi_endproc                             # end of the function	


.LFE2:                                           # start of .LFE2
	.size	sort, .-sort                     # size of the function	
	.globl	reverse                          # define the function reverse which is global 	
	.type	reverse, @function               # define type of revers , which is function 

reverse:                                        # reverse function starts
.LFB3:                                          # start of .LFB3
	.cfi_startproc                          # start of the function	
	endbr64                                 # end branch 64 bit	 
	pushq	%rbp                            # Save old base pointer 
	.cfi_def_cfa_offset 16                  # Set CFI to use offset of 16
	.cfi_offset 6, -16                      # set the offset of the register to -16	

	movq	%rsp, %rbp                      # rbp <-- rsp set new stack base pointer
	.cfi_def_cfa_register 6                 # set the CFA to the value of the register	
	movq	%rdi, -24(%rbp)                  #  1st argument, rdi -> rbp-24, str -> rbp-24
	movl	%esi, -28(%rbp)                  #  2nd argument, esi -> rbp-28,len -> rbp-28
	movq	%rdx, -40(%rbp)                  #  3rd argument, rdx -> rbp-40,  dest -> rbp-40	

	# for (i = 0; i < len / 2; i++)	
	movl	$0, -8(%rbp)                     # 0->rbp-8, assign 0 to i initialising first loop  ,  
	jmp	.L15                             # go to the for loop conditional check	


.L20:                                            # start of .L20
        # for (j = len - i - 1; j >= len / 2; j--)	          # [loop body]
	# assign the intialising value to j,( j = len - i - 1 )
	movl	-28(%rbp), %eax                                 # eax <-- rbp-28 , getting the len variable	
	subl	-8(%rbp), %eax                                  # eax - rbp-8 <-- eax , doing len- i
	subl	$1, %eax                                        # eax-1 <-- eax, subtracting 1 from len -i	
	movl	%eax, -4(%rbp)                                  # rbp-4 <-- eax
	nop # no operation	
	movl	-28(%rbp), %eax                                 # eax <-- rbp-28
	movl	%eax, %edx                                      # edx <-- eax
	shrl	$31, %edx                                       # shift the value of %edx right 31 bits, len / 2
	addl	%edx, %eax                                      # eax+edx <-- eax	
	sarl	%eax                                            # shift the value of %eax right by 1 bit	
	cmpl	%eax, -4(%rbp)                                  # compare the value of %eax to the value of j counter
	jl	.L18                                            # if value of j is less len / 2 then jump to .L18, out of the inner loop 
	movl	-8(%rbp), %eax                                  # rbp-8 -> eax,get the value of the i counter and store it in %rbp   
	cmpl	-4(%rbp), %eax                                  # rbp-4 -> eax,compare the value of the i counter(outer) to the value of the j counter(inner)
	je	.L23                                            # if equal jump to .L23	, break out of the loops	

    # temp = str[i]  
	movl	-8(%rbp), %eax                                  # rbp-8 -> eax, i -> eax	
	movslq	%eax, %rdx                                      # eax -> rdx, 32 bits to 64 bits		
	movq	-24(%rbp), %rax                                 # rbp-24 -> rax, str -> rax
	addq	%rdx, %rax                                      # rdx+rax -> rax, i + str = str[i] -> rax		
	movzbl	(%rax), %eax                                    # move the value of the register (%rax) to %eax		
	movb	%al, -9(%rbp)                                   # move the value of the register to the local array	

    
	# str[i]  = str[j] 
	movl	-4(%rbp), %eax                                  # rbp-4 -> eax, i -> eax
	movslq	%eax, %rdx                                      # eax -> rdx, 32 bits to 64 bits
	movq	-24(%rbp), %rax                                 # rbp-24 -> rax, str -> rax	
	addq	%rdx, %rax                                      # rax+rdx -> rdx, j + str = str[j] -> rdx	
	movl	-8(%rbp), %edx                                  # rbp-8 -> edx, j -> edx
	movslq	%edx, %rcx                                      # edx -> rcx, 32 bits to 64 bits	
	movq	-24(%rbp), %rdx                                 # rbp-24 -> rdx, str -> rdx	
	addq	%rcx, %rdx                                      # rcx+rdx -> rdx, j + str = str[j] -> rdx
	movzbl	(%rax), %eax                                    # move the value of the register %rax to %eax	
	movb	%al, (%rdx)                                     # move the value of the register to the memory	

	# str[j] =  temp 
 	movl	-4(%rbp), %eax                                  # rbp-4 -> eax, j -> eax
	movslq	%eax, %rdx                                      # eax -> rdx, 32 bits to 64 bits	
	movq	-24(%rbp), %rax                                 # rbp-24 -> rax, str -> rax	
	addq	%rax, %rdx                                      # rax+rdx -> rdx, j + str = str[j] -> rdx
	movzbl	-9(%rbp), %eax                                  # move the value of the register -9(%rbp) to %eax 
	movb	%al, (%rdx)                                     # move the value of the register to the memory	 

	# break out of the inner loop when the else condition is satisfied
	jmp	.L18                                                 # jump to .L18 , breaking out of the inner loop 
.L23:                                                               # start of .L23, the break-out stentatement for the if statement
	nop                                                         # no operation 

# for (i = 0; i < len; i++)
.L18:                                                              # start of .L18
	addl	$1, -8(%rbp)                                       # (rbp-8)+1 -> rbp-8, i+1 -> i (i++) 

.L15:  # start of .L15
	movl	-28(%rbp), %eax                                     # rbp-28 -> eax, len -> eax	
	movl	%eax, %edx                                          # move the value of the register %eax to %edx	
	shrl	$31, %edx                                           # shift the value of %edx right 31 bits	
	addl	%edx, %eax                                          # add the value of %edx to the value of %eax
	sarl	%eax                                                # shift the value of %eax right by the value of %eax
	cmpl	%eax, -8(%rbp)                                      # compare the value of %eax (len) to the i
	jl	.L20                                                # if less than jump to .L20 , go to the for loop conditional check

        # for (i = 0; i < len; i++) 
	movl	$0, -8(%rbp)                                        # 0->rbp-8, assign 0 to i	
	jmp	.L21                                                # jump to .L21
.L22:                                                              # start of .L22

    # dest[i] = str[i]
	movl	-8(%rbp), %eax                                      # rbp-8 -> eax, i -> eax
	movslq	%eax, %rdx                                          # eax -> rdx, 32 bits to 64 bits
	movq	-24(%rbp), %rax                                     # rbp-24 -> rax, dest -> rax
	addq	%rdx, %rax                                          # rdx+rax -> rax, i + dest = dest[i] -> rax		
	movl	-8(%rbp), %edx                                      # rbp-8 -> edx, i -> edx
	movslq	%edx, %rcx                                          # edx -> rcx, 32 bits to 64 bits
	movq	-40(%rbp), %rdx                                     # rbp-40 -> rdx, str -> rdx	
	addq	%rcx, %rdx                                          # rcx+rdx -> rdx, i + str = str[i] -> rdx	
	movzbl	(%rax), %eax                                        # move the value of the memory to the value of the register	 
	movb	%al, (%rdx)                                         # move the value of the register to the memory	
    addl	$1, -8(%rbp)                                        # (rbp-8)+1 -> rbp-8, i+1 -> i (i++)
        
.L21:                                                              # start of .L21
	movl	-8(%rbp), %eax                                      # rbp-8 -> eax, i -> eax	
	cmpl	-28(%rbp), %eax                                     # compare the value len to the i variable	
	jl	.L22                                                # if less than jump to .L22
	nop 
	nop
	popq	%rbp                                                 # pop the value of %rbp	
	.cfi_def_cfa 7, 8                                            # set content of register 7 and 8 to CFA
	ret                                                          # return from function 
	.cfi_endproc                                                 # end of the procedure	
	
.LFE3:                                                               # start of .LFE3
	.size	reverse, .-reverse                                   # size of the procedure
	.ident	"GCC: (Ubuntu 9.4.0-1ubuntu1~20.04.1) 9.4.0"         # identify the compiler
	.section	.note.GNU-stack,"",@progbits                 # set the stack unwind section
	.section	.note.gnu.property,"a"                       # set the GNU property section
	.align 8                                                    # align with 8 byte boundary
	.long	 1f - 0f                                             # set the length of the section
	.long	 4f - 1f                                             # set the length of the section
	.long	 5
0:                                                                  # start of 0
	.string	 "GNU"                                       # set the string	
1:                                                                  # start of 1
	.align 8                                                     # align with 8 byte boundary
	.long	 0xc0000002                                          # set the length of the section
	.long	 3f - 2f                                             # set the length of the section
2:                                                                  # start of 2
	.long	 0x3                                                # set the length of the section
3:                                                                 # start of 3
	.align 8                                                   # align with 8 byte boundary
4:                                                                # start of 4
