data segment
    a dw 1001h ; Initialize value of a
    b dw 0011h ; Initialize value of b
data ends

code segment
    assume cs:code, ds:data
start:
    mov ax, data
    mov ds, ax ; Initialize Data Segment

    mov ax, a
    mov bx, b
    mul bx ; Store lower 16 bit product in ax
    mov bx, ax ; Move ax value to bx for printing

    call printBx ; Print value in bx

    mov ah, 4ch ; Exit
    int 21h

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

code ends
end start
