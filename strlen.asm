.model small

.stack 100H   

.data 
    CR EQU 13 ; 
    LF EQU 10 ;  
    str1    db     'exemplo numero 1$'
.code  


LER_CHAR proc 
    mov AH, 7
    int 21H   
    ret       
endp
    
ESC_CHAR proc
    push AX   
    mov AH, 2
    int 21H
    pop AX     
    ret  
endp   

ESC_UINT16 proc 
    push AX      
    push BX
    push CX
    push DX 
       
    mov BX, 10   
    xor CX, CX   
      
LACO_DIV:
    xor DX, DX   
    div BX       
    
    push DX      
    inc CX       
     
    cmp AX, 0    
    jnz LACO_DIV 
           
 LACO_ESCDIG:   
    pop DX       
    add DL, '0'  
    call ESC_CHAR               
    loop LACO_ESCDIG    
    
    pop DX       
    pop CX
    pop BX
    pop AX
    ret     
endp   

LER_UINT16 proc  

    push BX
    push CX
    push DX 

    xor AX, AX 
    xor CX, CX
    mov BX, 10
                
LER_UINT16_SALVA:
    push AX    
     
LER_UINT16_LEITURA:       
    call LER_CHAR           
     
    cmp AL, CR              
    jz LER_UINT16_FIM         
      
    cmp AL, '0'             
    jb LER_UINT16_LEITURA 
  
    cmp AL, '9'
    ja LER_UINT16_LEITURA 
  
    mov DL, AL      
    call ESC_CHAR
  
    mov CL, AL      
    sub CL, '0'     
    
    pop AX           
    
    mul BX          
    add AX,CX
    
    jmp LER_UINT16_SALVA

LER_UINT16_FIM: 
    pop AX           
         
         
    mov DL, CR               
    call ESC_CHAR
    mov DL, LF             
    call ESC_CHAR

   
    pop DX
    pop CX
    pop BX
              
    ret
endp 
     
STRLEN proc
    push AX
    push DI 
    mov CX, -1
    cld
    LACO:  
         inc CX
         scasb   ;CF,PF,AF,ZF,SF,OF
         jne LACO
    pop DI
    pop AX
    ret   
endp  

INICIO:  
    mov AX, @DATA
    mov DS, AX 
    mov ES, AX
               
    mov AL,'$' 
    mov DI, offset str1  
    call STRLEN           
        
  
    mov ah, 4ch   
    int 21h
 end INICIO     
