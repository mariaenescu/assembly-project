; Enescu Maria 311CA
%include "../include/io.mac"

struc proc
    .pid: resw 1
    .prio: resb 1
    .time: resw 1
endstruc

section .text
    global sort_procs

sort_procs:
    ;; DO NOT MODIFY
    enter 0,0
    pusha

    mov edx, [ebp + 8]      ; processes
    mov eax, [ebp + 12]     ; length
    ;; DO NOT MODIFY

    ;; Your code starts here

	mov     ecx, eax
	shl     eax, 2
	add     eax, ecx
	xor     ecx, ecx

loop1:
    ; Daca ecx >= (ebx - 5) -> sare la sfarsitul loop-ului 1.
    ; Altfel, se continua cu instructiunile din interiorul loop-ului.

    mov     ebx, eax
    sub     ebx, 5
    
    cmp     ecx, ebx
    jge     loop1_end

    mov     ebx, ecx
    add     ebx, 5

loop2:
    ; Daca ebx >= eax -> ssare la sfarsitul loop-ului 2.
    ; Altfel, se efectueaza operatiile din interiorul buclei.

    cmp     ebx, eax
    jge     loop2_end

    mov     esi, edx
    
    push    edx
    push    eax

    mov     dl, byte [esi+ ecx + 2]

    mov     dh, byte [esi + ebx + 2]

    cmp     dl, dh
    jl      no_swap
    
    cmp     dl, dh
    je      check_time
        
swap:

    mov     ax, word [esi + ebx]
    xchg     word [esi + ecx], ax
    mov     word [esi + ebx], ax

    mov     byte [esi + ecx + 2], dh
    mov     byte [esi + ebx + 2], dl

    mov     ax, word [esi + ebx + 3]  
    xchg    word [esi + ecx + 3], ax
    mov     word [esi + ebx + 3], ax
    
    jmp     no_swap

check_time:
    ; Compara valorile de timp si decide daca este necesar un
    ; schimb intre valorile de la aceste pozitii.

    mov     ax, word [esi + ecx + 3]
    cmp     ax, word [esi + ebx + 3]
    je      check_pid

    cmp     ax, word [esi + ebx + 3]
    jg      swap

    jmp     no_swap

check_pid:
    ; Compara valorile PID-ului si decide daca este necesar un
    ; schimb intre valorile de la aceste pozitii.
    
    mov     ax, word [esi + ecx]

    cmp     ax, word [esi + ebx]
    jg      swap

no_swap:

    pop     eax
    pop     edx
    add     ebx, 5
    jmp     loop2

loop2_end:

    add     ecx, 5
    jmp     loop1

loop1_end:

    mov     eax, 0

    ;; Your code ends here
    
    ;; DO NOT MODIFY
    popa
    leave
    ret
    ;; DO NOT MODIFY