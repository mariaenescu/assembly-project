; Enescu Maria 311CA
%include "../include/io.mac"

section .text
    global simple
    extern printf

simple:
    ;; DO NOT MODIFY
    push    ebp
    mov     ebp, esp
    pusha

    mov     ecx, [ebp + 8]  ; len
    mov     esi, [ebp + 12] ; plain
    mov     edi, [ebp + 16] ; enc_string
    mov     edx, [ebp + 20] ; step

    ;; DO NOT MODIFY
   
    ;; Your code starts here

    mov     ebx, 26
    mov     eax, edx            
    
    ; Aceasta conditie este verificata pentru a evita impartirea la 0
    ; si pentru a preveni cazul in care edx >= 26.
    cmp     edx, 26
    jge     skip

    xor     edx, edx 
    div     ebx

skip:

    xor     ebx, ebx 

loop:
    ; Daca valoarea din ebx >= ecx -> ciclul se incheie.
    ; Altfel, se continua cu executia instructiunilor din interiorul buclei.

    cmp     ebx, ecx 
    jge     end  

    mov     al, byte [esi+ebx]
    add     al, dl

    ; Daca valoarea al <= 'Z' -> stringul de criptare este actualizat prin
    ; inlocuirea valorii din [edi+ebx] cu valoarea al.
    ; In caz contrar, se face o ajustare prin scaderea valorii cu 26 si
    ; se realizeaza inlocuirea in stringul de criptare.
    cmp     al, 'Z'
    jle     update_enc_string 

    sub     al, 26 

update_enc_string:

    xchg    byte [edi+ebx], al 
    add     ebx, 1

    jmp     loop

end:

    ;; Your code ends here
    ;; DO NOT MODIFY
    popa
    leave
    ret
    ;; DO NOT MODIFY
