.section .data
	MUNMAP_SYS_CALL = 91
	
	text: .ascii "Hello world! My name is {}. :)\n"
	text_length = . - text
	
	name: .ascii "Andrej"
	name_length = . - name
	
.section .text
.macro sys_write buffer, buffer_size
	movl \buffer, %ecx
	movl \buffer_size, %edx
	movl $4, %eax # WRITE_SYS_CALL
	movl $1, %ebx # stdout	
	int $0x80
.endm
.global main
main:
	pushl $name_length
	pushl $name
	pushl $text_length
	pushl $text
	call interpolate_string
	sys_write %eax, %edx
	addl $16, %esp
	
free:
	movl $MUNMAP_SYS_CALL, %eax
	popl %ebx # the address of the allocated memory (put on the stack right after mmap call)
	popl %ecx # the amount of memory that was allocated
	int $0x80
end:
	movl $1, %eax
	xorl %ebx, %ebx
	int $0x80