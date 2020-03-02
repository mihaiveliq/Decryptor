;Nume, prenume: Velicu, Mihai Corneliu
;Grupa, seria: 325, CA
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
	; TODO TASK 1
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
	; TODO TASK 2
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

xor_hex_strings:
	; TODO TASK 3
	ret

base32decode:
	; TODO TASK 4
	ret

bruteforce_singlebyte_xor:
	; TODO TASK 5
	push ebp
	mov ebp, esp
	mov ecx, [ebp + 8]
	mov esi, 0
suprascrie_sirul_criptat_task5:
	cmp byte [ecx + esi], 0
    je exit_suprascriere_task5
	xor byte [ecx + esi], al
	inc esi
	jmp suprascrie_sirul_criptat_task5

exit_suprascriere_task5:
	leave 
	ret

decode_vigenere:
	; TODO TASK 6
; 	push ebp
; 	mov ebp, esp
; 	mov ecx, [ebp + 8]
; 	mov eax, [ebp + 12]
; 	mov edx, 0
; restore_esi_task6:
;     mov esi, -1
; parcurge_string_key:
; 	cmp byte[ecx + edx], 0
; 	je exit_suprascriere_task6
; 	inc esi
; 	mov al, byte [eax + esi]
; 	cmp al, 0
; 	je restore_esi_task6
; 	cmp al, 'a'
; 	jge grater_than_a
; 	jmp parcurge_string_key
; grater_than_a:
; 	cmp al, 'z'
; 	jle lower_than_z
; 	inc edx
; 	jmp parcurge_string_key
; lower_than_z:
; 	sub al, 'a'
; 	mov bl, byte [ecx + edx]
; 	sub bl, al
; 	cmp bl, 'a'
; 	jle make_correct
; 	mov byte [ecx + edx], bl
; 	inc edx
; 	jmp parcurge_string_key
; make_correct:
; 	mov al, 'a'
; 	sub al, bl
; 	mov bl, 123
; 	sub bl, al
; 	mov byte [ecx + edx], bl
; 	inc edx
; 	jmp parcurge_string_key

; exit_suprascriere_task6:
; 	leave 
; 	ret

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
	cmp eax, 4
	je task4
	cmp eax, 5
	je task5
	cmp eax, 6
	je task6
	jmp task_done

task1:
	; TASK 1: Simple XOR between two byte streams

	; TODO TASK 1: find the address for the string and the key
	; TODO TASK 1: call the xor_strings function
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

	; TODO TASK 2: call the rolling_xor function
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
	; TASK 3: XORing strings represented as hex strings

	; TODO TASK 1: find the addresses of both strings
	; TODO TASK 1: call the xor_hex_strings function

	push ecx                     ;print resulting string
	call puts
	add esp, 4

	jmp task_done

task4:
	; TASK 4: decoding a base32-encoded string

	; TODO TASK 4: call the base32decode function
	
	push ecx
	call puts                    ;print resulting string
	pop ecx
	
	jmp task_done

task5:
	; TASK 5: Find the single-byte key used in a XOR encoding
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
found_key_task5:
	
	; TODO TASK 5: call the bruteforce_singlebyte_xor function
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

task6:
	; TASK 6: decode Vignere cipher

	; TODO TASK 6: find the addresses for the input string and key
	; TODO TASK 6: call the decode_vigenere function

	push ecx
	call strlen
	pop ecx

	add eax, ecx
	inc eax

; 	push eax
; 	push ecx
; 	call strlen
; 	pop ecx
; 	mov edx, eax
; 	mov ebx, edx
; 	dec ebx
; 	pop eax
; 	sub edx, 2

; restore_esi:
; 	mov esi, -1
; extindere_cheie:
; 	inc esi
; 	cmp ebx, esi
; 	je restore_esi
; inc_edx:
; 	inc edx
; 	cmp byte[ecx + edx], 0
; 	je concatenare_done
; 	cmp byte[ecx + edx], 'a'
; 	jle dont_change
; 	cmp byte[ecx + edx], 'z'
; 	jge dont_change
; 	mov bl, [eax + esi]
; 	mov byte[eax + edx], bl
; 	jmp extindere_cheie
; dont_change:
; 	mov bl, byte[ecx + edx]
; 	mov [eax + edx], bl
; 	jmp inc_edx
; concatenare_done:

	push eax
	push ecx                   ;ecx = address of input string 
	call decode_vigenere
	pop ecx
	add esp, 4

	push ecx
	call puts
	add esp, 4

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
