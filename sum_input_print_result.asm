.data        

.stack 100H   ; Define a 256 bytes stack 

.code    

    ; Write char stored in DL    
    WRT_CHAR proc
        push AX    ; store AX
        mov AH, 2
        int 21H
        pop AX     ; restore AX
        ret  
    endp   
    
    ; Write an 16bit integer without signal stored at AX 
    WRT_UINT16 proc 
        push AX    
        push BX
        push CX
        push DX 
           
        mov BX, 10   ; Successive division by 10
        xor CX, CX   ; Digit counter
          
    WHILE_DIV:
        xor DX, DX   ;  clear DX, the dividend is DXAX
        div BX       ; Divide to separate the DX digit
        
        push DX      ; stack the digit
        inc CX       
         
        cmp AX, 0  
        jnz WHILE_DIV ; while AX is not 0, redo
               
     WHILE_WRTDIG:   
        pop DX       ; unstack the digit    
        add DL, '0'  ; Convert the digit to ASCII
        call WRT_CHAR               
        loop WHILE_WRTDIG ; Decrement digit counter

        pop DX       ; Restore the registers
        pop CX
        pop BX
        pop AX
        ret     
    endp 


    ;  Write an 16bit integer with the signal stored at AX 
    WRT_INT16 proc 
        push AX         
        cmp AX, 0 ; Se AX < 0, SF = 1
        jns WRITE_NUMBER
     
        ; write the signal
        mov DL, '-'    
        call WRT_CHAR 
     
        neg AX ; invert signal
    
    WRITE_NUMBER:
        call WRT_UINT16

        pop AX   
        ret
    endp    
     
    
    READCHAR PROC ; Read from keyboard and assign to AL
        MOV AH,07 ;
        INT 33 ;
        RET ; Return to the caller
    READCHAR ENDP ;
       
    START:
        mov AX, @DATA ; Inicialize data segment 
           
        call READCHAR 
        sub AL, 30h ;Convert ASCII digit ('0'-'9') to integer  
        mov AH, 0 ; Clear the higher bytes
        
        mov BX, AX
        
        xor AX, AX ; Clear the register
        
        call READCHAR  
        sub AL, 30h ;Convert ASCII digit ('0'-'9') to integer
        mov AH, 0 ; Clear the higher bytes
        
        add AX, BX   
        
        call WRT_INT16  
        
        int 21H ; Call DOS interruption to kill the program     
    end START


