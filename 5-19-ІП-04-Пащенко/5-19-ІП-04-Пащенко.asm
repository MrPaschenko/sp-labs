.386

.model flat, stdcall
    option casemap:none
    include C:\masm32\include\masm32rt.inc
    
.data?
    BUFFER_PASHCHENKO_ANSWER dd 6 dup(?)
    BUFFER_PASHCHENKO_FINAL_ANSWER dd 6 dup(?)
    
    BUFFER_PASHCHENKO dd 86 dup(?)
    BUFFER_PASHCHENKO_OUTPUT dd 512 dup(?)
    
.data
    PASHCHENKO_NAME db "5-19-ІП-04-Пащенко", 0
    
    PASHCHENKO_A_ARRAY dd 2, 3, 2, 3, 4, 2
    PASHCHENKO_C_ARRAY dd 6, -12, 6, 4, 3, -1
    PASHCHENKO_D_ARRAY dd 5, 3, -10, -1, -2, 19
    
    PASHCHENKO_TASK db "Task is (12 / c - d * 4 + 73) / (a * a + 1)", 10, 10, 0
    
    PASHCHENKO_ANSWER db "a = %d, c = %d, d = %d", 10,
    "(12 / %d - %d * 4 + 73) / (%d * %d + 1)", 10,
    "Answer is %d", 10, 
    "Final answer is %d", 10, 10, 0
    
    PASHCHENKO_ERROR_ZERO db "a = %d, c = %d, d = %d", 10,
    "(12 / %d - %d * 4 + 73) / (%d * %d + 1)", 10,
    "You cannot divide by zero", 10, 10, 0
    
.code
    Main:
        mov edi, 0
        invoke wsprintf, addr BUFFER_PASHCHENKO_OUTPUT, addr PASHCHENKO_TASK
        
        .while edi <= 5
            ; calculate (12 / c - d * 4 + 73)
            ; 1 - calculate (12 / c)
            mov eax, 12
            mov ebx, PASHCHENKO_C_ARRAY[4*edi]
            cmp ebx, 0
            je error_zero
            cdq
            idiv ebx
            ; eax = (12 / c)
            
            ; 2 - calculate (d * 4)
            mov ebx, PASHCHENKO_D_ARRAY[4*edi]
            imul ebx, 4
            ; ebx = (d * 4)
            
            ; 3 - calculate (12 / c - d * 4 + 73)
            sub eax, ebx 
            ; eax = (12 / c - d * 4)
            add eax, 73
            ; eax = (12 / c - d * 4 + 73)
            
            ; calculate (a * a + l)
            ; 1 - calculate (a * a)
            mov ebx, PASHCHENKO_A_ARRAY[4*edi]
            imul ebx, ebx
            ; ebx = (a * a)
            
            ; 2 - calculate (a * a + 1)
            inc ebx
            ; ebx = (a * a + 1)
            
            ; calculate (12 / c - d * 4 + 73) / (a * a + l)
            cmp ebx, 0
            je error_zero
            cdq
            idiv ebx
            ; eax = (12 / c - d * 4 + 73) / (a * a + l)
            
            mov BUFFER_PASHCHENKO_ANSWER[4*edi], eax
            
            ;check if even or odd
            test eax, 1
                jnz @odd
                jz @even
            @even:
                mov esi, 2
                cdq
                idiv esi
                ; eax = eax / 2
                jmp @endTest
            @odd:
                imul eax, 5
                ; eax = eax * 5
            @endTest:
            mov BUFFER_PASHCHENKO_FINAL_ANSWER[4*edi], eax
            mov BUFFER_PASHCHENKO, 0
            
            invoke wsprintf, addr BUFFER_PASHCHENKO, addr PASHCHENKO_ANSWER, 
            PASHCHENKO_A_ARRAY[4*edi], PASHCHENKO_C_ARRAY[4*edi], PASHCHENKO_D_ARRAY[4*edi], 
            PASHCHENKO_C_ARRAY[4*edi], PASHCHENKO_D_ARRAY[4*edi], PASHCHENKO_A_ARRAY[4*edi], PASHCHENKO_A_ARRAY[4*edi],
            BUFFER_PASHCHENKO_ANSWER[4*edi], BUFFER_PASHCHENKO_FINAL_ANSWER[4*edi]
            
            jmp continue
            
            error_zero:
                invoke wsprintf, addr BUFFER_PASHCHENKO, addr PASHCHENKO_ERROR_ZERO,
                PASHCHENKO_A_ARRAY[4*edi], PASHCHENKO_C_ARRAY[4*edi], PASHCHENKO_D_ARRAY[4*edi], 
                PASHCHENKO_C_ARRAY[4*edi], PASHCHENKO_D_ARRAY[4*edi], PASHCHENKO_A_ARRAY[4*edi], PASHCHENKO_A_ARRAY[4*edi]
            continue:
                invoke szCatStr, addr BUFFER_PASHCHENKO_OUTPUT, addr BUFFER_PASHCHENKO
                inc edi
        .endw
        invoke MessageBox, 0, addr BUFFER_PASHCHENKO_OUTPUT, addr PASHCHENKO_NAME, 0
        
    end Main