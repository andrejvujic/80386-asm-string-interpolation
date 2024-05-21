.section .data
	MMAP2_SYS_CALL = 192
.section .text
.global interpolate_string
interpolate_string:
	pushl %ebp
	movl %esp, %ebp
	pushl %ebx
	pushl %esi
	pushl %edi
	
	#  8(%ebp), original string
	# 12(%ebp), original string length
	# 16(%ebp), string to insert
	# 20(%ebp), string to insert length

	movl 12(%ebp), %edx
	subl $2, %edx # subtract the length for the {}
	addl 20(%ebp), %edx # add the length of the string to insert
	
	pushl %edx
	
	movl $MMAP2_SYS_CALL, %eax
	movl $0, %ebx # NULL, doesn't matter where the memory is at
	movl %edx, %ecx # the amount of bytes to allocate is the length of the new string
	movl $3, %edx # prot: PROT_READ | PROT_WRITE
	movl $34, %esi # flags: MAP_PRIVATE | MAP_ANONYMOUS = 34
	movl $-1, %edi # fd
	pushl %ebp
	movl $0, %ebp # pgoffset
	int $0x80	
	popl %ebp

	popl %edx

	pushl %eax # save the start address of the allocated memory
	pushl %edx # save the length of the allocated memory
	movl $0, %esi
	movl 8(%ebp), %edi
	
look_for_opening_curly_brace:	
	cmpb $'{', (%edi)
	je found_opening_curly_brace
	
	cmpl 12(%ebp), %esi
	je error_operning_curly_brace_not_found
	
	movb (%edi), %bl
	movb %bl, (%eax)
	
	incl %eax
	incl %edi
	incl %esi
	jmp look_for_opening_curly_brace
	
found_opening_curly_brace:
	incl %esi 
	incl %edi
	cmpb $'}', (%edi) # closing curly brace not found
	jne look_for_opening_curly_brace
	
	# skip the closing curly brace
	incl %edi
	incl %esi
	
	pushl %esi
	pushl %edi
	
	movl $0, %esi
	movl 16(%ebp), %edi

insert_given_string:
	cmpl 20(%ebp), %esi
	je end_insert_given_string
	
	movb (%edi), %bl
	movb %bl, (%eax)
	
	incl %eax
	incl %edi
	incl %esi
	jmp insert_given_string
	
end_insert_given_string:
	popl %edi
	popl %esi

copy_left_over_original_string_bytes:
	cmpl 12(%ebp), %esi
	je end_interpolate_string
	
	movb (%edi), %bl
	movb %bl, (%eax)
	
	incl %eax
	incl %edi
	incl %esi
	jmp copy_left_over_original_string_bytes

error_operning_curly_brace_not_found:		
	# the given string couldn't be inserted,
	# so the original string is returned
	movl 8(%ebp), %eax
	movl 12(%ebp), %edx
	
end_interpolate_string:
	popl %edx
	popl %eax
	
	popl %edi
	popl %esi
	popl %ebx
	movl %ebp, %esp
	popl %ebp
	ret