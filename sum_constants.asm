.data        

.code                 
    START:
        mov AX, @DATA ; Inicialize data segment    
            
        mov CX, 32
        mov AX, 10
        
        add AX, CX     
        
        int 21H ; Call DOS interruption to kill the program
    end START

