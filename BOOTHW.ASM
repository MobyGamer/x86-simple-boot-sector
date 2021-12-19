segment bootsect byte public 'CODE'
assume cs:bootsect, ds:bootsect

;We comment this line out because we set COMFILE on the command-line,
;which allows us to build both versions from a batch file
;COMFILE EQU     0                       ;0 = boot sector, 1 = DOS .COM file
BOOTLOC EQU     7C00h

IF COMFILE EQ 1
        org     100h
ELSE
        org     BOOTLOC
ENDIF

start proc

IF COMFILE EQ 0

        ;Set up registers similar to how DOS loads a .COM file, to protect us
        ;from making bad assumptions writing our code

        clc
        cld
        push    cs
        pop     ss
        push    cs
        pop     ds
        xor     ax,ax
        xor     bx,bx
        mov     cx,0FFh
        mov     si,offset start
        mov     sp,0FFFEh
        mov     di,sp
ENDIF

        mov     si,offset hello_message ;point ds:si to our message string
        mov     cx,1                    ;write one character at a time

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

IF COMFILE EQ 1
        int     20h                     ;Exit to DOS
ELSE
        xor     dx,dx                   ;DL = drive containing boot sector
        int     19h                     ;reboot
ENDIF

IF COMFILE EQ 1
hello_message:  db      'Hello from DOS!',0
ELSE
hello_message:  db      'Hello, world!',0
ENDIF

IF COMFILE EQ 0
        org     BOOTLOC+512-2
        db      055h,0AAh               ;end-of-boot-sector signature
ENDIF

endp start
ends bootsect
end start
