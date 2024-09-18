.data        

.code    

.stack 100H   ; Define a 256 bytes stack
    
    READCHAR PROC ; Read from keyboard and assign to AL
        MOV AH,07 ;
        INT 33 ;
        RET ; Return to the caller
    READCHAR ENDP ;
       
    START:
        mov AX, @DATA ; Inicialize data segment    
        call READCHAR 
        AAA ; ASCII Adjust for Addition
        mov BL, AL
        
        xor AL, AL ; Clear the register
        
        call READCHAR  
        AAA
        mov AL, AL
        
        add AL, BL     
        
        int 21H ; Call DOS interruption to kill the program     
    end START

