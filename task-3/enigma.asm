; Enescu Maria 311CA
%include "../include/io.mac"

;; defining constants, you can use these as immediate values in your code
LETTERS_COUNT EQU 26

section .data
    extern len_plain

section .text
    global rotate_x_positions
    global enigma
    extern printf

; void rotate_x_positions(int x, int rotor, char config[10][26], int forward);
rotate_x_positions:
    ;; DO NOT MODIFY
    push ebp
    mov ebp, esp
    pusha

    mov eax, [ebp + 8]  ; x
    mov ebx, [ebp + 12] ; rotor
    mov ecx, [ebp + 16] ; config (address of first element in matrix)
    mov edx, [ebp + 20] ; forward
    ;; DO NOT MODIFY
    ;; TODO: Implement rotate_x_positions
    ;; FREESTYLE STARTS HERE

	push    edx
	mov     edi, eax
	mov     eax, ebx

	mov     ebp, LETTERS_COUNT
	shl     ebp, 1
	imul    ebp
	
	mov     esi, eax
	add     esi, ecx
	
	mov     eax, edi
	mov     edi, esi 
	add     edi, LETTERS_COUNT

	mov     ebp, LETTERS_COUNT
	dec     ebp
	
	pop     edx
	cmp     edx, 1
	je      rotate_right

	xor     edx, edx
	
left_first_for:

	cmp     edx, eax
	jge     rotate_end

	xor     ecx, ecx

	mov     bl, byte [esi]
	mov     bh, byte [edi]
left_second_for:

	cmp     ecx, ebp
	je      left_end_second_for

	push    eax
	mov     al, byte [esi + ecx + 1]
	mov     byte[esi + ecx], al
	
	mov     al, byte [edi + ecx + 1]
	mov     byte[edi + ecx], al

	pop     eax

	inc     ecx

	jmp     left_second_for

left_end_second_for:

	mov     byte [esi + ebp], bl
	mov     byte [edi + ebp], bh

	inc     edx
	
	jmp     left_first_for
	
rotate_right:

	xor     edx, edx
first_for:

	cmp     edx, eax
	jge     rotate_end
	
	mov     ecx, ebp
	mov     bl, byte [esi + ebp]
	mov     bh, byte [edi + ebp]
second_for:

	cmp     ecx, 0
	jle     end_second_for

	push    eax

	mov     al, byte [esi + ecx - 1]
	mov     byte[esi + ecx], al

	mov     al, byte [edi + ecx - 1]
	mov     byte[edi + ecx], al

	pop     eax
	
	dec     ecx

	jmp     second_for
	
end_second_for:

	mov     byte [esi], bl
	mov     byte [edi], bh

	inc     edx
	
	jmp     first_for

rotate_end:

	mov     eax, 0

    ;; FREESTYLE ENDS HERE
    ;; DO NOT MODIFY
    popa
    leave
    ret
    ;; DO NOT MODIFY

; void enigma(char *plain, char key[3], char notches[3], char config[10][26], char *enc);
enigma:
    ;; DO NOT MODIFY
    push ebp
    mov ebp, esp
    pusha

    mov eax, [ebp + 8]  ; plain (address of first element in string)
    mov ebx, [ebp + 12] ; key
    mov ecx, [ebp + 16] ; notches
    mov edx, [ebp + 20] ; config (address of first element in matrix)
    mov edi, [ebp + 24] ; enc
    ;; DO NOT MODIFY
    ;; TODO: Implement enigma
    ;; FREESTYLE STARTS HERE
	
	xor     esi, esi
next_char:

	; Verificam daca am ajuns la sfarsitul textului ce trebuie codificat
	cmp     esi, [len_plain]
	jge     finish

	push    ebx
	push    esi

	; Rotim rotor 3 cu o pozitie la stanga 
	push    edi
	push    edx
	push    ecx
	push    ebx
	push    eax
	
	mov     esi, 0

	push    esi
	push    edx

	mov     esi, 2
	push    esi

	mov     esi, 1
	push    esi

	call    rotate_x_positions
	add     esp, 16
	
	pop     eax
	pop     ebx
	pop     ecx
	pop     edx
	pop     edi
	
	; Incrementam key rotorului 3 cu 1 si daca depasim Z punem A 
	push    eax
	mov     al, byte [ebx + 2]
	mov     ah, al
	inc     al

	cmp     al, 'Z' ; Daca se depaseste Z inlocuim cu A
	jle     change_key_rotor_3

	sub     al, LETTERS_COUNT
change_key_rotor_3:

	mov     byte [ebx + 2], al  ; Salvam noua key corespunzatoare rotorului 3
	
	; Comparam key originala a rotorului 3 (pastrata in ah) cu notch-ul
    ; pentru rotor 3 si daca sunt egale rotim rotorul 2 cu o pozitie la stanga
	cmp     ah, byte [ecx + 2] ; Daca nu sunt egale incepem cryptarea
	jne     start_encrypt

	pop eax

	; Rotim rotor 2 cu o pozitie la stanga 
	push    edi
	push    edx
	push    ecx
	push    ebx
	push    eax
	
	mov     esi, 0
	push    esi
	push    edx
	mov     esi, 1
	push    esi
	mov     esi, 1
	push    esi
	call    rotate_x_positions
	add     esp, 16
	
	pop     eax
	pop     ebx
	pop     ecx
	pop     edx
	pop     edi

	; Incrementam key pentru rotor 2 cu 1 si daca depasim Z punem A 
	push eax

	mov     al, byte [ebx + 1]
	mov     ah, al
	inc     al

	cmp     al, 'Z'
	jle     change_key_rotor_2

	sub     al, LETTERS_COUNT
change_key_rotor_2:

	mov     byte [ebx + 1], al
	
	; Comparam key originala a rotorului 2 (pastrata in ah) cu notch-ul
    ; pentru rotor 2 si daca sunt egale incrementam key rotorului 1
	cmp     ah, byte [ecx + 1]
	jne     start_encrypt
	
	; Incrementam key pentru rotor 1 cu 1 si daca depasim Z punem A 
	mov     al, byte [ebx]
	inc     al

	cmp     al, 'Z'
	jle     change_key_rotor_1

	sub     al, LETTERS_COUNT
change_key_rotor_1:

	mov     byte [ebx], al

start_encrypt:

	pop     eax
	pop     esi

	mov     ebx, 0
	mov     bl, byte [eax + esi]

	; Gasim positia in plugboard
	; Luam caracterul de la pozitia (caracter - 'A') din plugboard si
    ; cautam in partea a doua a plugboard-ului.
    ; Plugboard-ul incepe de la pozitia 208 (primele 26 caractere) si
    ; 234 (urmatoarele 26 caractere)
	sub     bl, 'A'
	mov     bl, byte [edx + ebx + 208] 

	push    esi
	push    ecx 
	push    eax

	xor     ecx, ecx
for_plugboard:

	cmp     ecx, LETTERS_COUNT
	jge     finish
    
	cmp     bl, byte [edx + ecx + 234]
	je      find_in_rotor

	inc     ecx

	jmp     for_plugboard
	
	; 1. Luam caracterul de la pozitia ecx (gasita in plugboard) si
    ;    cautam in rotorul 3. Rotorul 3 incepe de la pozitia
    ;    104 (primele 26 caractere) si 130 (urmatoarele 26 caractere)
	; 2. Luam caracterul de la pozitia ecx (gasita in rotor 3) si
    ;    cautam in rotorul 2. Rotorul 2 incepe de la pozitia 52
    ;    (primele 26 caractere) si 78 (urmatoarele 26 caractere)
	; 3. Luam caracterul de la pozitia ecx (gasita in rotor 2) si
    ;    cautam in rotorul 1. Rotorul 1 incepe de la pozitia 0
    ;    (primele 26 caractere) si 26 (urmatoarele 26 caractere)
	; Simulam un for pentru a trece prin totii rotorii.
find_in_rotor:

	mov     bh, 0
next_rotor:

	cmp     bh, 3
	jge     find_in_reflector
	
	push    edx
	mov     eax, 0 

    ; bh - Numarul rotorului.
    ; Pentru a afla adresa primei parti a rotorului folosim bh*52.
    ; Astfel, in eax vom afla adresa de inceput a rotorului i.  
	mov     al, bh 
	mov     bl, 52
	imul    bl

	pop     edx
    ; esi = ecx + 130 - eax (gasirea caracterului in a doua parte a rotorului)
	mov     esi, 130 
	add     esi, ecx
	sub     esi, eax

    ; bl - retine caracterul ce trebuie gasit
	mov     bl, byte [edx + esi]

	xor     ecx, ecx
for_rotor:

    ; Parcurgem prima parte a rotorului pentru a gasi pozitia
    ; unde se gaseste caracterul 
	cmp     ecx, LETTERS_COUNT
	jge     finish

    ; esi = ecx + 104 - eax (gairea caracterului din bl in prima parte
    ; a rotorului)
	mov     esi, 104 
	add     esi, ecx
	sub     esi, eax

	cmp     bl, byte [edx + esi]
	je      find_in_next_rotor

	inc     ecx

	jmp     for_rotor

find_in_next_rotor:

    ; Cautam in rotorul urmator.
	inc     bh		
	jmp     next_rotor
	
    ; Cautam caracterul de la pozitia ecx din rotor 1 in prima parte
    ; a reflectorului-ului. Reflectorul-ul incepe de la pozitia 156
    ; (primele 26 caractere) si 182 (urmatoarele 26 caractere).
find_in_reflector:

	mov     bl, byte [edx + ecx + 156]
	xor     ecx, ecx

for_reflector:
    ; Cautam pozitia caracterului bl din reflector
    ; in partea a doua a reflectorului.

	cmp     ecx, LETTERS_COUNT
	jge     finish

	cmp     bl, byte [edx + ecx + 182]
	je      find_in_rotor_back

	inc     ecx

	jmp     for_reflector
	
	; Parcurgem rotoarele in sens invers (rotor 1, rotor 2 si apoi rotor 3)
    ; conform celor specificate mai sus cu observatia ca se ia litera din
    ; prima parte a rotorului si apoi se cauta pozitia ei in partea a doua
    ; a rotorului.
find_in_rotor_back:

	mov     bh, 0
next_rotor_back:

	cmp     bh, 3
	jge     find_in_plugboard

	push edx

	mov     eax, 0
	mov     al, bh
	mov     bl, 52
	imul    bl

	pop     edx

	mov     esi, ecx
	add     esi, eax

	mov     bl, byte [edx + esi]

	xor     ecx, ecx
for_rotor_back:

	cmp     ecx, LETTERS_COUNT
	jge     finish

	mov     esi, ecx ; esi = ecx + 26 + al
	add     esi, eax
	add     esi, 26

	cmp     bl, byte [edx + esi]
	je      find_in_next_rotor_back

	inc     ecx

	jmp     for_rotor_back

find_in_next_rotor_back:

	inc     bh

	jmp     next_rotor_back

	; Cautam caracterul de la pozitia ecx din rotor 3 in partea
    ; a doua a plugboard-ului. 
find_in_plugboard:

	mov     bl, byte [edx + ecx + 234]
	xor     ecx, ecx

for_plugboard_back:

	cmp     ecx, LETTERS_COUNT
	jge     finish

	cmp     bl, byte [edx + ecx + 208]
	je      save_char

	inc     ecx

	jmp     for_plugboard_back

	; Se salveaza noul caracter gasit (bl) in pozitia lui
    ; corespunzatoare din edi.
save_char:

	pop     eax
	pop     ecx
	pop     esi
	mov     byte [edi + esi], bl
	
	inc     esi
	pop     ebx

    ; Se trece la codificarea celorlalte caractere din textul plain.
	jmp     next_char 
	
finish:

	mov     eax, 0

    ;; FREESTYLE ENDS HERE
    ;; DO NOT MODIFY
    popa
    leave
    ret
    ;; DO NOT MODIFY