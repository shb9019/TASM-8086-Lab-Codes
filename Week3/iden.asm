data segment
    mat dw 255 dup('?')
    n dw ?
    entern db "Enter n $"
    enterRow db "Enter row values : $"
    isIdentityMsg db "Given matrix is identity matrix $"
    isNotIdentityMsg db "Given matrix is not an identity matrix $"
    lnfd db 0ah, 0dh, "$"
data ends

code segment
    assume cs:code, ds:data
start:
    mov ax, data
    mov ds, ax ; Initialize data segment

    ; Read n
    mov ah, 09h
    mov dx, offset entern
    int 21h
    call printNewline

    call readBx
    mov n, bx

    ; Double loop to read the matrix
    mov ax, n
    lea si, mat
    l1:
    push ax
    call printNewline
    mov ah, 09h
    mov dx, offset enterRow
    int 21h
    mov bx, n
        l2:
        push bx
        call readBx
        mov [si], bx
        pop bx
        inc si
        dec bx
        jnz l2
    pop ax
    dec ax
    jnz l1

    call printNewline

    ; Check for identity matrix
    mov ax, 0
    lea si, mat
    lo1:
    mov bx, 0
        lo2:

        push ax
        push bx
        call printBx
        mov bx, ax
        call printBx
        call printNewline
        pop bx
        pop ax

        cmp ax, bx
        jnz cnt1
        push ax
        mov ax, [si]
        cmp ax, 0001h
        pop ax
        jnz isNotIden
        jmp cnt2
        cnt1:
        push ax
        mov ax, [si]
        cmp ax, 0000h
        pop ax
        jnz isNotIden
        cnt2:
        inc si
        inc bx
        cmp bx, n
        jnz lo2
    inc ax
    cmp ax, n
    jnz lo1

    isIden:
    mov ah, 09h
    mov dx, offset isIdentityMsg
    int 21h
    jmp exit

    isNotIden:
    mov ah, 09h
    mov dx, offset isNotIdentityMsg
    int 21h

    exit:
    call printNewline
    mov ah, 4ch
    int 21h

    printBxRev proc
        push ax ; Store current value of ax

        ; Print Least Significant Nibble in bx
        mov ax, bx
        and ax, 000Fh ; Make all nibbles 0 other than least significant
    
        mov dl, al
        add dl, "0" ; Convert to ASCII from hex
        cmp dl, "9"
        jle rcont3
        add dl, 7

        rcont3:
        mov ah, 02h ; Print character to stdout
        int 21h

        ; Print Second Least Significant Nibble in bx
        mov ax, bx
        and ax, 00F0h ; Make all nibbles 0 other than second least significant
        shr ax, 4 ; Shift Right by 1 nibble to get second least significant nibble of bx in least of ax
    
        mov dl, al
        add dl, "0" ; Convert to ASCII from hex
        cmp dl, "9"
        jle rcont2
        add dl, 7

        rcont2:
        mov ah, 02h ; Print character to stdout
        int 21h

        ; Print Second Most Significant Nibble in bx
        mov ax, bx
        and ax, 0F00h ; Make all nibbles 0 other than second most significant
        shr ax, 8 ; Shift Right by 2 nibbles to get second most significant nibble of bx in least of ax
    
        mov dl, al
        add dl, "0" ; Convert to ASCII from hex
        cmp dl, "9"
        jle rcont1
        add dl, 7

        rcont1:
        mov ah, 02h ; Print character to stdout
        int 21h

        ; Print Most Significant Nibble in bx
        mov ax, bx
        shr ax, 12 ; Shift Right by 3 nibbles to get most significant nibble of bx in least of ax
    
        mov dl, al
        add dl, "0" ; Convert to ASCII from hex
        cmp dl, "9"
        jle rcont0
        add dl, 7

        rcont0:
        mov ah, 02h ; Print character to stdout
        int 21h

        pop ax ; Restore value of ax
        ret
    printBxRev endp

    readBx proc
        push ax ; Store current value of ax

        mov bx, 0000h ; Initialize value of bx to 0

        mov ah, 01h ; Set DOS interrupt to read character from stdin
        int 21h ; Read
        cmp al, "9"
        jle read0 ; If character is less than 9 jump to read0
        sub al, 7h ; Subtract by 7 (Difference between ascii of 'A' and '9')
        read0:
        sub al, 30h ; Subtract by 30 to convert to number from ascii
        add bl, al
        shl bx, 4 ; Shift value by nibble to left

        int 21h
        cmp al, "9"
        jle read1
        sub al, 7h
        read1:
        sub al, 30h
        add bl, al
        shl bx, 4

        int 21h
        cmp al, "9"
        jle read2
        sub al, 7h
        read2:
        sub al, 30h
        add bl, al
        shl bx, 4

        int 21h
        cmp al, "9"
        jle read3
        sub al, 7h
        read3:
        sub al, 30h
        add bl, al

        pop ax ; Restore original value of ax
        ret
    readBx endp

    printBx proc
        push ax ; Store current value of ax

        ; Print Most Significant Nibble in bx
        mov ax, bx
        shr ax, 12 ; Shift Right by 3 nibbles to get most significant nibble of bx in least of ax

        mov dl, al
        add dl, "0" ; Convert to ASCII from hex
        cmp dl, "9"
        jle cont0
        add dl, 7
        cont0:
        mov ah, 02h ; Print character to stdout
        int 21h

        ; Print Second Most Significant Nibble in bx
        mov ax, bx
        and ax, 0F00h ; Make all nibbles 0 other than second most significant
        shr ax, 8 ; Shift Right by 2 nibbles to get second most significant nibble of bx in least of ax

        mov dl, al
        add dl, "0" ; Convert to ASCII from hex
        cmp dl, "9"
        jle cont1
        add dl, 7
        cont1:
        mov ah, 02h ; Print character to stdout
        int 21h

        ; Print Second Least Significant Nibble in bx
        mov ax, bx
        and ax, 00F0h ; Make all nibbles 0 other than second least significant
        shr ax, 4 ; Shift Right by 1 nibble to get second least significant nibble of bx in least of ax

        mov dl, al
        add dl, "0" ; Convert to ASCII from hex
        cmp dl, "9"
        jle cont2
        add dl, 7
        cont2:
        mov ah, 02h ; Print character to stdout
        int 21h

        ; Print Least Significant Nibble in bx
        mov ax, bx
        and ax, 000Fh ; Make all nibbles 0 other than least significant

        mov dl, al
        add dl, "0" ; Convert to ASCII from hex
        cmp dl, "9"
        jle cont3
        add dl, 7
        cont3:
        mov ah, 02h ; Print character to stdout
        int 21h

        pop ax ; Restore value of ax
        ret
    printBx endp

    printString proc
        mov ah, 09h
        int 21h
    printString endp

    printReg proc
        call printBx
        call printNewline

        push bx

        mov bx, ax
        call printBx
        call printNewline

        mov bx, cx
        call printBx
        call printNewline

        mov bx, dx
        call printBx
        call printNewline

        pop bx
        ret
    printReg endp

    printNewline proc
        push ax
        push dx
        mov ah, 09h
        mov dx, offset lnfd
        int 21h
        pop dx
        pop ax
        ret
    printNewline endp

code ends
end start