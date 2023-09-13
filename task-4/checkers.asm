; Enescu Maria 311CA
section .data

section .text
	global checkers

checkers:
    ;; DO NOT MODIFY
    push ebp
    mov ebp, esp
    pusha

    mov eax, [ebp + 8]	; x
    mov ebx, [ebp + 12]	; y
    mov ecx, [ebp + 16] ; table

    ;; DO NOT MODIFY
    ;; FREESTYLE STARTS HERE

	xchg    eax, ebx

    mov     edx, ebx
    shl     edx, 3            
    add     edx, eax

	mov     ah, 1

    cmp     al, 0
    jne     x_not_0

    cmp     ebx, 0
    jne     y_not_0

	mov     byte [ecx + edx + 9], ah
    jmp     end_x

y_not_0:
    
    cmp     ebx, 7
    jne     y_not_7

    mov     byte [ecx + edx - 7], ah 

    jmp     end_x

y_not_7:

    mov     byte [ecx + edx + 9], ah
	mov     byte [ecx + edx - 7], ah
    jmp     end_x

x_not_0:
    ;; Etape:
    ;;      * Compara valoarea lui al (partea mica a lui eax) cu 7
    ;;          ** Daca al != 7 -> sare la labelul x_not_7.
    ;;      * Altfel, verifica daca coordonata y (ebx) = 0.
    ;;          ** Daca ebx != 0 -> sare la labelul y_not_0_x_7.
    ;;      * Altfel, seteaza byte-ul la adresa [ecx + edx + 7] cu valoarea ah.

    cmp     al, 7
    jne     x_not_7

    cmp     ebx, 0
    jne     y_not_0_x_7

    mov     byte [ecx + edx + 7], ah

    jmp     end_x

y_not_0_x_7:
    ;; Etape:
    ;;      * Daca ebx != 7 -> sare la labelul y_not_7_x_7.
    ;;      * Altfel, seteaza byte-ul la adresa [ecx + edx - 9] cu valoarea ah.

    cmp     ebx, 7
    jne     y_not_7_x_7

    mov     byte [ecx + edx - 9], ah
    jmp     end_x

y_not_7_x_7:

    mov     byte [ecx + edx - 9], ah
	mov     byte [ecx + edx + 7], ah
    jmp     end_x

x_not_7:
    ;; Etape:
    ;;      * Daca ebx != 0 -> sare la labelul y_not_0_x.
    ;;      * Altfel, seteaza byte-ul la adresa [ecx + edx + 9] cu valoarea ah
    ;;        si byte-ul la adresa [ecx + edx + 7] cu tot cu valoarea ah.

    cmp     ebx, 0
    jne     y_not_0_x

	mov     byte [ecx + edx + 9], ah
	mov     byte [ecx + edx + 7], ah
    jmp     end_x

y_not_0_x:
    ;; Etape:
    ;;      * Daca ebx != 7 -> sare la labelul y_not_7_x.
    ;;      * Altfel, seteaza byte-ul la adresa [ecx + edx - 9] cu valoarea ah
    ;;        si byte-ul la adresa [ecx + edx - 7] cu tot cu valoarea ah.

    cmp     ebx, 7
    jne     y_not_7_x

	mov     byte [ecx + edx - 9], ah
	mov     byte [ecx + edx - 7], ah

    jmp     end_x

y_not_7_x:

    mov     byte [ecx + edx - 9], ah
	mov     byte [ecx + edx - 7], ah
	mov     byte [ecx + edx + 9], ah
	mov     byte [ecx + edx + 7], ah
    jmp     end_x

end_x:

	mov     eax, 0

    ;; FREESTYLE ENDS HERE
    ;; DO NOT MODIFY
    popa
    leave
    ret
    ;; DO NOT MODIFY