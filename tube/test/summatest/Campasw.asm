;06/29/94 08:26am

        .486
	.MODEL	FLAT
    LOCALS @@
   DATA    SEGMENT WORD PUBLIC USE32
           ASSUME DS:DATA
   DATA    ENDS

   CODE    SEGMENT BYTE PUBLIC USE32
           ASSUME CS:CODE

basaddr equ     360h
ainf1   equ     basaddr
ainf2   equ     basaddr+1
ainf3   equ     basaddr+2
adrqx   equ     basaddr+3
adran   equ     basaddr+3
adrf    equ     basaddr+4
adrc    equ     basaddr+5
adrl1   equ     basaddr+6
adrl2   equ     basaddr+7

 
TSumma@setcr   proc pascal
        public TSumma@setcr
        arg     @scr:word,@Self:dword
        push    ebp
        push    ebx
        mov     ax,word ptr @scr
        mov     dx,adrc
        out     dx,al
        pop     ebx
        pop     ebp
        ret

TSumma@setcr    endp

TSumma@instrc   proc 
        public  TSumma@instrc

        push    bp
        mov     bp,sp
        push    bx
        mov     dx,adran
        mov     al,0
        out     dx,al
        mov     dx,adrf
        mov     al,80h
        out     dx,al
        call    waitk
        mov     ax,dx
        xchg    al,ah
        pop     bx
        mov     sp,bp
        pop     bp
        ret
TSumma@instrc   endp

TSumma@instrz   proc 
        public  TSumma@instrz

        push    bp
        mov     bp,sp
        push    bx
        mov     dx,adran
        mov     al,0
        out     dx,al
        mov     dx,adrf
        mov     al,40h
        out     dx,al
        call    waitk
        mov     ax,dx
        xchg    al,ah
        pop     bx
        mov     sp,bp
        pop     bp
        ret
TSumma@instrz   endp

TSumma@getlam   proc 
        public  TSumma@getlam

        mov     dx,adrl1
        in      al,dx
        mov     ah,al
        inc     dx
        in      al,dx
        xchg    al,ah
        ret
TSumma@getlam   endp

TSumma@rcam24   proc pascal    
        public  TSumma@rcam24
        arg     @cr:byte,@nr:byte,@ar:byte,@fr:byte,@self:dword

        push    bp
        push    bx
	mov	al,@cr
	mov	ah,@nr
	mov	bl,@ar
	mov	bh,@fr
        call    wcnaf
        call    waitk
        mov     dh,dl
        mov     bx,dx
        mov     dx,ainf3
        in      al,dx
        mov     bl,al
        mov     dx,ainf2
        in      al,dx
        mov     ah,al
        mov     dx,ainf1
        in      al,dx
        mov     dx,bx

; result in dx,ax dut for Delphi must in eax,do it
        
        xchg    ax,dx
        shl     eax,16
        mov     ax,dx
        pop     bx
        pop     bp
        ret
TSumma@rcam24   endp

TSumma@rcam16   proc pascal    
        public  TSumma@rcam16
        arg     @cr:byte,@nr:byte,@ar:byte,@fr:byte,@self:dword

        push    bp
        push    bx
	mov	al,@cr
	mov	ah,@nr
	mov	bl,@ar
	mov	bh,@fr
        call    wcnaf
        call    waitk
        mov     dh,dl
        mov     dl,0
        mov     bx,dx
        mov     dx,ainf2
        in      al,dx
        mov     ah,al
        mov     dx,ainf1
        in      al,dx
        mov     dx,bx

; result in dx,ax dut for Delphi must in eax,do it
        
        xchg    ax,dx
        shl     eax,16
        mov     ax,dx
        pop     bx
        pop     bp
        ret
TSumma@rcam16   endp

TSumma@wcam24   proc pascal
        public  TSumma@wcam24
        arg     @cr:byte,@nr:byte,@ar:byte,@fr:byte,@dr:dword,@self:dword

        push    bp
        push    bx
        mov     eax,@dr
        mov     dx,ainf1
        out     dx,al
        inc     dx
        xchg    al,ah
        out     dx,al
        shr     eax,16
        inc     dx
        out     dx,al
        mov     dx,ainf3
       	mov	al,@cr
	mov	ah,@nr
	mov	bl,@ar
	mov	bh,@fr
        call    wcnaf
        call    waitk
        mov     ax,dx
        xchg    al,ah
        pop     bx
        pop     bp
        ret
TSumma@wcam24   endp

TSumma@wcam16   proc pascal
        public  TSumma@wcam16
        arg     @cr:byte,@nr:byte,@ar:byte,@fr:byte,@dr:word,@self:dword

        push    bp
        push    bx
        mov     ax,@dr
        mov     dx,ainf1
        out     dx,al
        inc     dx
        xchg    al,ah
        out     dx,al
	mov	al,@cr
	mov	ah,@nr
	mov	bl,@ar
	mov	bh,@fr
        call    wcnaf
        call    waitk
        mov     ax,dx
        xchg    al,ah
        pop     bx
        pop     bp
        ret
TSumma@wcam16   endp

TSumma@ccamac   proc pascal
        public  TSumma@ccamac
        arg     @cr:byte,@nr:byte,@ar:byte,@fr:byte,@self:dword

        push    bp
        push    bx
	mov	al,@cr
	mov	ah,@nr
	mov	bl,@ar
	mov	bh,@fr
        call    wcnaf
        call    waitk
        mov     ax,dx
        xchg    al,ah
        pop     bx
        pop     bp
        ret
TSumma@ccamac   endp

wcnaf   proc    near
        mov     dx,adrc
        out     dx,al

        mov     cl,ah
        and     cx,1fh
        mov     al,bl
        and     al,0fh
        shl     cx,1
        shl     cx,1
        shl     cx,1
        shl     cx,1
        or      al,cl
        mov     dx,adran
        out     dx,al

        mov     al,bh
        and     ax,1fh
        shl     al,1
        or      al,ch
        mov     dx,adrf
        out     dx,al
        ret
wcnaf   endp

waitk   proc    near
        mov     ecx,10
        mov     dx,adrqx
        in      al,dx
        test    al,8
        jnz     @@lwait
        mov     ax,4
        jmp     @@wind
@@lwait:  in      al,dx
        test    al,4
        jz      @@kok
        loop    @@lwait
        mov     ax,1
        jmp     @@wind
@@kok:    test    al,1
        jz      @@xok
        mov     ax,2
        jmp     @@wind
@@xok:    test    al,2
        jz      @@qxok
        mov     ax,3
        jmp     @@wind
@@qxok:   xor     ax,ax
@@wind:   mov     ah,al
        mov     dx,ax
        ret
waitk   endp

   CODE    ends

        END