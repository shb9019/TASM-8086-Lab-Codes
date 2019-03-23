data segment
    mat1 dw 10 dup('?')
    mat2 dw 10 dup('?')
    n dw ?
    m dw ?
    entern db "Enter n $"
    enterm db "Enter m $"
    enterRow1 db "Enter row values of matrix 1 : $"
    enterRow2 db "Enter row values of matrix 2 : $"
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

    ; Read n
    mov ah, 09h
    mov dx, offset enterm
    int 21h
    call printNewline
    call readBx
    mov m, bx

    ; Double loop to read the matrix 1
    mov ax, n
    lea si, mat1
    l1:
    push ax
    call printNewline
    mov ah, 09h
    mov dx, offset enterRow1
    int 21h
    mov bx, m
        l2:
        push bx
        call readBx
        mov [si], bx
        pop bx
        inc si
        inc si
        dec bx
        jnz l2
    pop ax
    dec ax
    jnz l1
    call printNewline

    ; Double loop to read the matrix
    mov ax, n
    lea si, mat2
    l11:
    push ax
    call printNewline
    mov ah, 09h
    mov dx, offset enterRow2
    int 21h
    mov bx, m
        l21:
        push bx
        call readBx
        mov [si], bx
        pop bx
        inc si
        inc si
        dec bx
        jnz l21
    pop ax
    dec ax
    jnz l11
    call printNewline

    ; Calculate difference of matrices
    mov cx, n
    lea si, mat1
    lea di, mat2
    lo1:
    mov bx, m
        lo2:
        push ax
        push bx
        mov ax, [si]
        mov bx, [di]
        sub ax, bx
        mov [si], ax
        pop bx
        pop ax
        inc si
        inc si
        inc di
        inc di
        dec bx
        jnz lo2
    inc ax
    loop lo1

    ; Print matrix
    mov ax, n
    lea si, mat1
    l111:
    push ax
    mov bx, m
        l211:
        push bx
        mov bx, [si]
        call printBx
        pop bx
        inc si
        inc si
        dec bx
        jnz l211
    pop ax
    call printNewline
    dec ax
    jnz l111

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