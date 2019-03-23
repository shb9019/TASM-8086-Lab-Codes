print macro msg
	mov dx, offset msg
	mov ah,09h
	int 21h
	endm


printcharacter macro x
	mov ah,2h
	mov dl,x
	call convertToAscii
	int 21h
	endm

DATA SEGMENT
msg db 0dh,0ah, "error is there: $"
filename db "example.txt",0
string db 100 dup(0)
newline db 0dh,0ah, " $"
handle dw ?
temp_string db 20 dup(0)
total_count db 0
temp_si dw 0
DATA ENDS

CODE SEGMENT
assume cs:code, ds:data
start:
mov ax,data
mov ds,ax

;; open file
mov ax,3d02h
lea dx,filename
int 21h
jc error
mov handle,ax

;; read from file
mov ah,3fh
mov bx,handle
mov cx,100
lea dx,string
int 21h
jc error

mov total_count,al
;;print contents in file read
print string
printcharacter total_count
print newline

;; close file
mov	ah,3eh
mov	bx,handle
int	21h
jmp main_part

error:
	print msg
	mov ah,4ch
	int 21h

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;----------------------------
main_part:

mov cl,0
mov si,0
mov bl,0
mov di,0

loop1:
	cmp cl,total_count
	JZ end1
	inc cl

	cmp string[si],' '
	JNZ pk4
	inc si
	cmp bl,1
	JNZ pk
	mov temp_string[di],'$'
	print temp_string
	print newline
	pk:
	mov bl,0
	mov di,0
	mov temp_si,si
	call refresh_temp_string
	mov si,temp_si
	JMP loop1 

	pk4:
	cmp string[si],'s'
	JZ pk2
	mov bh,string[si]
	mov temp_string[di],bh
	inc di
	inc si
	JMP loop1
	

	pk2:
		mov bl,1
		mov bh,string[si]
		mov temp_string[di],bh
		inc di
		inc si
		JMP loop1

;;;;;;;;;;;;;;;;;;;;;--------------------------------------------------------------


end1:
cmp bl,1
JNZ end2
mov temp_string[di],'$'
print temp_string
end2:
mov ah,4ch
int 21h


refresh_temp_string proc
	mov ch,0
	mov si,0
	loop2:
		cmp ch,20
		JZ end3
		mov temp_string[si],0
		inc ch
		inc si
		JMP loop2

	end3:
		ret
		endp

convertToAscii proc
	cmp dl,10
	jc jk
	add dl,7h
	jk:
		add dl,48
	ret
	endp

CODE ENDS
END START
