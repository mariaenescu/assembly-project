; Enescu Maria 311CA
section .data
    line db 0b10100000
section .text
    global bonus
bonus:
    ;; DO NOT MODIFY
    push ebp
    mov ebp, esp
    pusha

    mov eax, [ebp + 8]	; x
    mov ebx, [ebp + 12]	; y
    mov ecx, [ebp + 16] ; board

    ;; DO NOT MODIFY
    ;; FREESTYLE STARTS HERE

    mov     dl, byte [line]

    push    ecx
    mov     ecx, ebx 

    ; x = 7 ; shl 1
    cmp     ecx, 7
    je      shift

    dec     ecx

    mov     ch, 5
    sub     ch, cl

    xchg    ch, cl
    shr     dl, cl

    jmp     break
shift:

    shl     dl,  1
break:

    pop     ecx

    ;; y = 0 -> k1 = 5, k2 = 3
    ;; y = 1 -> k1 = 6, k2 = 4
    ;; y = 2 -> k1 = 7, k2 = 5
    ;; y = 3 -> k1 = 0, k2 = 6
    ;; y = 4 -> k1 = 1, k2 = 7
    ;; y = 5 -> k1 = 2, k2 = 0
    ;; y = 6 -> k1 = 3, k2 = 1
    ;; y = 7 -> k1 = 4, k2 = 2

    ; De aici putem desprinde regulile:
    ; - Pentru y = {0, 1, 2} -> k1 = y + 5
    ; - Pentru y = {3, 4, 5, 6} -> k1 = y - 3
    ; - Pentru y = {7} -> k1 = nu exista
    
    mov     esi, eax

    cmp     esi, 2
    jle     case1

    cmp     esi, 6
    jle     case2

    cmp     esi, 7
    je      index_bottom_line

case1:

    add     esi, 5
    jmp     upper_line

case2:

    sub     esi, 3

    jmp     upper_line
upper_line:

    or      [ecx + esi], dl
index_bottom_line:

    ; De aici putem desprinde regulile:
    ; - Pentru y = {0} -> k2 = nu exista
    ; - Pentru y = {1, 2, 3, 4} -> k2 = y + 3
    ; - Pentru y = {5, 6, 7} -> k2 = y - 5

    mov     edi, eax

    cmp     edi, 0
    je      end

    cmp     edi, 5
    jl      case3
    
    sub     edi, 5

    jmp     bottom_line
case3:

    add     edi, 3
bottom_line:

    or      [ecx + edi], dl
end:

    ;; FREESTYLE ENDS HERE
    ;; DO NOT MODIFY
    popa
    leave
    ret
    ;; DO NOT MODIFY