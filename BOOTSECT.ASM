segment bootsect byte public 'CODE'
assume cs:bootsect, ds:bootsect

        org     7C00h

start proc

        ;Ensure DS is similar to how DOS loads a .COM file, to protect
        ;us from making bad assumptions writing our code

        push    cs
        pop     ds                      ;DS = CS

        mov     si,offset hello_message ;point ds:si to our message string
        mov     cx,1                    ;write one character at a time
        xor     bx,bx                   ;point to text page 0

printmessage:
        lodsb                           ;load a character
        or      al,al                   ;is it nul (0)?
        jz      endprog                 ;if so, we're done printing
        mov     ah,0eh                  ;int 10h,0ah = write in teletype mode
                                        ;set AH every time b/c BIOS changes it
        int     10h                     ;if not done printing, print our char
        jmp     printmessage            ;continue reading characters

endprog:
        xor     ax,ax                   ;int 16h,00 = get keypress
        int     16h                     ;wait for keypress

        xor     dx,dx                   ;DL = drive containing boot sector
        int     19h                     ;reboot

hello_message:  db 'Hello, world!',0

        org     7C00h + (512-2)
        db      055h,0AAh               ;end-of-boot-sector signature

endp start
ends bootsect
end start
