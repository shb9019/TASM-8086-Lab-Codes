printString macro msg
    mov ah, 09h
    mov dx, offset msg
    int 21h
endm

data segment
    entern db "Enter n : $"
    n dw ?
    hexVal dw ?
    binVal db 17 dup('$')
    hexMsg db "Hexadecimal number is $"
    binMsg db "Binary number is $"
    lnfd db 0ah, 0dh, "$"
data ends

code segment
    assume cs:code, ds:data
start:
    mov ax, data
    mov ds, ax ; Initialize data segment

    ; Read n
    printString entern
    call readBx
    mov n, bx

    ; Represent decimal number in hexadecimal
    mov ax, n
    mov bx, 0
    mov cx, 0001h
    loop2:
    xor dx, dx

    push cx
    mov cx, 10h
    div cx
    pop cx

    push ax
    mov ax, cx
    mul dx
    add bx, ax
    pop ax

    push ax
    push bx
    mov ax, cx
    mov bx, 10
    mul bx
    mov cx, ax
    pop bx
    pop ax
    cmp ax, 0
    jnz loop2

    mov n, bx
    call printNewline
    printString hexMsg
    call printBx
    mov hexVal, bx

    ; Represent hexadecimal in binary
    mov ax, hexVal
    mov bx, 0
    lea si, binVal
    loop3:
    xor dx, dx

    push cx
    mov cx, 02h
    div cx
    pop cx

    add dl, '0'
    mov [si], dl

    inc si
    cmp ax, 0
    jnz loop3

    call printNewline
    printString binMsg
    mov di, offset binVal
    loop4:
    dec si
    mov ah, 02h
    mov dl, [si]
    int 21h
    cmp si, di
    jnz loop4

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