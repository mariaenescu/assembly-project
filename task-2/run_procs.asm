; Enescu Maria 311CA
%include "../include/io.mac"

    ;;
    ;;   TODO: Declare 'avg' struct to match its C counterpart
    ;;

struc proc
    .pid: resw 1
    .prio: resb 1
    .time: resw 1
endstruc

    ;; Hint: you can use these global arrays
section .data
    prio_result dd 0, 0, 0, 0, 0
    time_result dd 0, 0, 0, 0, 0

section .text
    global run_procs

run_procs:
    ;; DO NOT MODIFY

    push ebp
    mov ebp, esp
    pusha

    xor ecx, ecx

clean_results:

    mov dword [time_result + 4 * ecx], dword 0
    mov dword [prio_result + 4 * ecx],  0

    inc ecx
    cmp ecx, 5
    jne clean_results

    mov ecx, [ebp + 8]      ; processes
    mov ebx, [ebp + 12]     ; length
    mov eax, [ebp + 16]     ; proc_avg
    ;; DO NOT MODIFY
   
    ;; Your code starts here

	mov     esi, ecx
	mov     edi, eax
	
	mov     ecx, ebx
	shl     ecx, 2
	add     ebx, ecx
	
	xor     ecx, ecx
	inc     ecx
	
loop1:

    cmp     ecx, 5
    jg      loop1_end

    xor     edx, edx 

loop2:

    cmp     edx, ebx
    jge     loop2_end
    
    ; Se realizeaza comparatia dintre valoarea eax și ecx.
    ; Daca acestea nu sunt egale -> se sare la eticheta go_next.
    ; Daca sunt egale -> se executa actualizarea rezultatelor(time si prio).
    mov     eax, 0
    mov     al, byte [esi + edx + 2]
    cmp     eax, ecx
    jne     go_next
    
    mov     ax, word [esi + edx + 3]
    add     eax, dword [time_result + (ecx - 1) * 4]
    mov     dword [time_result + (ecx - 1) * 4], eax
    mov     eax, dword [prio_result + (ecx - 1) * 4]
    inc     eax
    mov     dword [prio_result + (ecx - 1) * 4], eax
    
go_next:

    add     edx, 5

    jmp     loop2

loop2_end:

    inc     ecx
    jmp     loop1

loop1_end:

    xor     ecx, ecx
calc_start:
    ; Se verifica daca  ecx >= 5.
    ; Daca da -> sare la calc_end
    ; Daca nu -> se continua cu restul instructiunilor

    cmp     ecx, 5
    jge     calc_end

    mov     eax, dword [time_result + ecx * 4]
    mov     ebx, dword [prio_result + ecx * 4]
    mov     edx, 0
calc_1:

    cmp     eax, 0
    je      calc_next 
    div     ebx
        
calc_next:

    mov     word [edi + ecx * 4], ax
    mov     word [edi + ecx * 4 + 2], dx

    inc     ecx 
    jmp     calc_start

calc_end:

    mov     eax, 0
    ;; Your code ends here
    
    ;; DO NOT MODIFY
    popa
    leave
    ret
    ;; DO NOT MODIFY