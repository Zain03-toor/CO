.model small
.stack 200h

.data
    top_border  db '  +==============================+', 13, 10, '$'
    empty_line  db '  |                              |', 13, 10, '$'
    date_line   db '  |  Date: 00/00/0000            |', 13, 10, '$'
    sep_line    db '  |  ----------------------------  |', 13, 10, '$'
    time_line   db '  |  Time: 00:00:00              |', 13, 10, '$'
    bot_border  db '  +==============================+$'

.code
main proc
    mov ax, @data
    mov ds, ax

    mov ah, 06h
    mov al, 00h
    mov bh, 1Eh
    mov cx, 0000h
    mov dx, 184Fh
    int 10h

main_loop:

    ; DATE
    mov ah, 2Ah
    int 21h

    mov al, dl
    call bta
    mov [date_line+8], al
    mov [date_line+9], ah

    mov al, dh
    call bta
    mov [date_line+11], al
    mov [date_line+12], ah

    mov ax, cx
    mov dx, 0
    mov bx, 1000
    div bx
    add al, '0'
    mov [date_line+14], al

    mov ax, dx
    mov dx, 0
    mov bx, 100
    div bx
    add al, '0'
    mov [date_line+15], al

    mov ax, dx
    mov dx, 0
    mov bx, 10
    div bx
    add al, '0'
    mov [date_line+16], al
    add dl, '0'
    mov [date_line+17], dl

    ; TIME
    mov ah, 2Ch
    int 21h

    mov al, ch
    call bta
    mov [time_line+8], al
    mov [time_line+9], ah

    mov al, cl
    call bta
    mov [time_line+11], al
    mov [time_line+12], ah

    mov al, dh
    call bta
    mov [time_line+14], al
    mov [time_line+15], ah

    ; DRAW
    mov ah, 02h
    mov bh, 00h
    mov dh, 07h
    mov dl, 00h
    int 10h

    mov ah, 09h
    lea dx, top_border
    int 21h

    lea dx, empty_line
    int 21h

    lea dx, empty_line
    int 21h

    lea dx, date_line
    int 21h

    lea dx, empty_line
    int 21h

    lea dx, sep_line
    int 21h

    lea dx, empty_line
    int 21h

    lea dx, time_line
    int 21h

    lea dx, empty_line
    int 21h

    lea dx, empty_line
    int 21h

    lea dx, bot_border
    int 21h

    mov ah, 86h
    mov cx, 000Fh
    mov dx, 4240h
    int 15h

    jmp main_loop

main endp

bta proc
    mov ah, 0
    mov bl, 10
    div bl
    add al, '0'
    add ah, '0'
    ret
bta endp

end main