extern puts
extern printf
extern strlen

%define BAD_ARG_EXIT_CODE -1

section .data
filename: db "./input0.dat", 0
inputlen: dd 2263

fmtstr:            db "Key: %d",0xa, 0
usage:             db "Usage: %s <task-no> (task-no can be 1,2,3,4,5,6)", 10, 0
error_no_file:     db "Error: No input file %s", 10, 0
error_cannot_read: db "Error: Cannot read input file %s", 10, 0

section .text
global main

xor_strings:
	; TASK 1
	push ebp
	mov ebp, esp
	mov ecx, [ebp + 8]
	mov ebx, [ebp + 12]
    xor esi, esi
suprascrie_sirul_criptat_task1:
	cmp byte[ecx+esi], 0
    je exit_suprascriere_task1
	mov al, byte [ebx + esi]
	xor al, byte [ecx + esi]
	mov byte [ecx + esi], al
	inc esi
	jmp suprascrie_sirul_criptat_task1

exit_suprascriere_task1:
	leave 
	ret

rolling_xor:
	; TASK 2
	push ebp
	mov ebp, esp
	mov ecx, [ebp + 8]
	mov esi, 0
	mov bl, byte [ecx + esi]
suprascrie_sirul_criptat_task2:
	cmp byte[ecx + esi + 1], 0
    je exit_suprascriere_task2
	mov al, bl
	mov bl, byte [ecx + esi + 1]
	xor byte [ecx + esi + 1], al
	inc esi
	jmp suprascrie_sirul_criptat_task2

exit_suprascriere_task2:
	leave 
	ret

bruteforce_singlebyte_xor:
	; TASK 3
	push ebp
	mov ebp, esp
	mov ecx, [ebp + 8]
	mov esi, 0
suprascrie_sirul_criptat_task3:
	cmp byte [ecx + esi], 0
    je exit_suprascriere_task3
	xor byte [ecx + esi], al
	inc esi
	jmp suprascrie_sirul_criptat_task3

exit_suprascriere_task3:
	leave 
	ret

main:
	push ebp
	mov ebp, esp
	sub esp, 2300

	; test argc
	mov eax, [ebp + 8]
	cmp eax, 2
	jne exit_bad_arg

	; get task no
	mov ebx, [ebp + 12]
	mov eax, [ebx + 4]
	xor ebx, ebx
	mov bl, [eax]
	sub ebx, '0'
	push ebx

	; verify if task no is in range
	cmp ebx, 1
	jb exit_bad_arg
	cmp ebx, 6
	ja exit_bad_arg

	; create the filename
	lea ecx, [filename + 7]
	add bl, '0'
	mov byte [ecx], bl

	; fd = open("./input{i}.dat", O_RDONLY):
	mov eax, 5
	mov ebx, filename
	xor ecx, ecx
	xor edx, edx
	int 0x80
	cmp eax, 0
	jl exit_no_input

	; read(fd, ebp - 2300, inputlen):
	mov ebx, eax
	mov eax, 3
	lea ecx, [ebp-2300]
	mov edx, [inputlen]
	int 0x80
	cmp eax, 0
	jl exit_cannot_read

	; close(fd):
	mov eax, 6
	int 0x80

	; all input{i}.dat contents are now in ecx (address on stack)
	pop eax
	cmp eax, 1
	je task1
	cmp eax, 2
	je task2
	cmp eax, 3
	je task3
	jmp task_done

task1:
	; TASK 1: Simple XOR between two byte streams

	; find the address for the string and the key
	; call the xor_strings function
        push eax
        push edx
        push ebx
        xor esi, esi
compare:
        inc esi
        cmp byte[ecx + esi - 1], 0
        jne compare
        lea ebx, [ecx + esi]
        push ebx
        push ecx
        call xor_strings
        sub esp, 8

	push ecx
	call puts                   ;print resulting string
	add esp, 4
        
        pop edx
        pop ebx
        pop eax

	jmp task_done

task2:
	; TASK 2: Rolling XOR

	; call the rolling_xor function
	push eax
    push edx
    push ebx

    push ecx
    call rolling_xor
    sub esp, 4

	push ecx
	call puts                   ;print resulting string
	add esp, 4
        
    pop edx
	pop ebx
    pop eax

	jmp task_done

task3:
	; TASK 3: Find the single-byte key used in a XOR encoding
	push eax
    push edx
    push ebx

	mov al, 0
	mov esi, 0
	mov bl, byte [ecx + esi]
test_bl:
	cmp bl, 0
    je inc_eax
check_f:
	xor bl, al
	cmp bl, 'f'
	jne inc_esi
check_fo:
	inc esi
	mov bl, byte [ecx + esi]
	cmp bl, 0
    je inc_eax
	xor bl, al
	cmp bl, 'o'
	jne inc_esi
check_for:
	inc esi
	mov bl, byte [ecx + esi]
	cmp bl, 0
    je inc_eax
	xor bl, al
	cmp bl, 'r'
	jne inc_esi
check_forc:
	inc esi
	mov bl, byte [ecx + esi]
	cmp bl, 0
    je inc_eax
	xor bl, al
	cmp bl, 'c'
	jne inc_esi
check_force:
	inc esi
	mov bl, byte [ecx + esi]
	cmp bl, 0
    je inc_eax
	xor bl, al
	cmp bl, 'e'
	jne inc_esi
	jmp found_key_task5
inc_esi:
	inc esi
	mov bl, byte [ecx + esi]
	jmp test_bl
inc_eax:
	inc al
	mov esi, 0
	mov bl, byte [ecx + esi]
	jmp test_bl
found_key_task3:
	
	; call the bruteforce_singlebyte_xor function
	push ecx
    call bruteforce_singlebyte_xor
    sub esp, 4

	push eax

	push ecx                    ;print resulting string
	call puts
	pop ecx

	pop eax

	push eax                    ;eax = key value
	push fmtstr
	call printf                 ;print key value
	add esp, 8

	pop edx
	pop ebx
    pop eax

	jmp task_done

task_done:
	xor eax, eax
	jmp exit

exit_bad_arg:
	mov ebx, [ebp + 12]
	mov ecx , [ebx]
	push ecx
	push usage
	call printf
	add esp, 8
	jmp exit

exit_no_input:
	push filename
	push error_no_file
	call printf
	add esp, 8
	jmp exit

exit_cannot_read:
	push filename
	push error_cannot_read
	call printf
	add esp, 8
	jmp exit

exit:
	mov esp, ebp
	pop ebp
	ret
