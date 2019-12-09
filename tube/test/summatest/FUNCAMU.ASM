;01/20/94 09:21am
        DOSSEG
        .MODEL LARGE
        .STACK 100h
        .DATA

        .CODE
funcam   segment byte public 'CODE'
        public  _setcr,_rcam16,_wcam16,_rcam24,_wcam24
        public  _ccamac,_instrc,_instrz,_getlam

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

        assume  cs:funcam,ds:nothing,ss:nothing,es:nothing

_setcr  proc    far
        arg     scr:word

        push    bp
        mov     bp,sp
        push    bx
        mov     ax,[scr]
        mov     dx,adrc
        out     dx,al
        pop     bx
        mov     sp,bp
        pop     bp
        ret
_setcr  endp

_instrc proc    far
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
_instrc endp

_instrz proc    far
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
_instrz endp

_getlam proc    far
        mov     dx,adrl1
        in      al,dx
        mov     ah,al
        inc     dx
        in      al,dx
        xchg    al,ah
        ret
_getlam endp

_rcam24 proc    far
        arg     cr:word,nr:word,ar:word,fr:word

        push    bp
        mov     bp,sp
        push    bx
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
        pop     bx
        mov     sp,bp
        pop     bp
        ret
_rcam24 endp

_rcam16 proc    far
        arg     cr:word,nr:word,ar:word,fr:word

        push    bp
        mov     bp,sp
        push    bx
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
        pop     bx
        mov     sp,bp
        pop     bp
        ret
_rcam16 endp

_wcam24 proc    far
        arg     cr:word,nr:word,ar:word,fr:word,dr:dword

        push    bp
        mov     bp,sp
        push    bx
        les     bx,dr
        mov     ax,bx
        mov     dx,ainf1
        out     dx,al
        inc     dx
        xchg    al,ah
        out     dx,al
        les     bx,dr+1
        mov     al,bh
        mov     dx,ainf3
        call    wcnaf
        call    waitk
        mov     ax,dx
        xchg    al,ah
        pop     bx
        mov     sp,bp
        pop     bp
        ret
_wcam24 endp

_wcam16 proc    far
        arg     cr:word,nr:word,ar:word,fr:word,dr:word

        push    bp
        mov     bp,sp
        push    bx
        mov     ax,[dr]
        mov     dx,ainf1
        out     dx,al
        inc     dx
        xchg    al,ah
        out     dx,al
        call    wcnaf
        call    waitk
        mov     ax,dx
        xchg    al,ah
        pop     bx
        mov     sp,bp
        pop     bp
        ret
_wcam16 endp

_ccamac proc    far
        arg     cr:word,nr:word,ar:word,fr:word

        push    bp
        mov     bp,sp
        push    bx
        call    wcnaf
        call    waitk
        mov     ax,dx
        xchg    al,ah
        pop     bx
        mov     sp,bp
        pop     bp
        ret
_ccamac endp

wcnaf   proc    near
        mov     ax,[cr]
        mov     dx,adrc
        out     dx,al

        mov     cx,[nr]
        and     cx,1fh
        mov     ax,[ar]
        and     al,0fh
        shl     cx,1
        shl     cx,1
        shl     cx,1
        shl     cx,1
        or      al,cl
        mov     dx,adran
        out     dx,al

        mov     ax,[fr]
        and     ax,1fh
        shl     al,1
        or      al,ch
        mov     dx,adrf
        out     dx,al
        ret
wcnaf   endp

waitk   proc    near
        mov     cx,10
        mov     dx,adrqx
        in      al,dx
        test    al,8
        jnz     lwait
        mov     ax,4
        jmp     wind
lwait:  in      al,dx
        test    al,4
        jz      kok
        loop    lwait
        mov     ax,1
        jmp     wind
kok:    test    al,1
        jz      xok
        mov     ax,2
        jmp     wind
xok:    test    al,2
        jz      qxok
        mov     ax,3
        jmp     wind
qxok:   xor     ax,ax
wind:   mov     ah,al
        mov     dx,ax
        ret
waitk   endp
funcam  ends

        END