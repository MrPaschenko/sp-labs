include \masm32\include\masm32rt.inc
    
.data?
    ANSWER_ONE                  dq ?
    ANSWER_TWO                  dq ?
    ANSWER_THREE                dq ?
    ANSWER_FOUR                 dq ?
    ANSWER_FIVE                 dq ?
    ANSWER_SIX                  dq ?
    ANSWER_SEVEN                dq ?
    ANSWER_EIGHT                dq ?
    
    STRING_ANSWER_ONE           db 32 dup(?)
    STRING_ANSWER_TWO           db 32 dup(?)
    STRING_ANSWER_THREE         db 32 dup(?)
    STRING_ANSWER_FOUR          db 32 dup(?)
    STRING_ANSWER_FIVE          db 32 dup(?)
    STRING_ANSWER_SIX           db 32 dup(?)
    STRING_ANSWER_SEVEN         db 32 dup(?)
    STRING_ANSWER_EIGHT         db 32 dup(?)
    
    STRING_A                    db 32 dup(?)
    STRING_B                    db 32 dup(?)
    STRING_C                    db 32 dup(?)
    STRING_D                    db 32 dup(?)
    
    BUFFER                      db 1024 dup(?)
    BUFFER_OUTPUT               db 1024 dup(?)
    
.data
    PASHCHENKO_NAME             db "6-19-ІП-04-Пащенко", 0
    
    ;                                1       2       3       4       5
    PASHCHENKO_A_ARRAY          dq  2.1,    3.2,    1.1,    -1.4,   -2.5
    PASHCHENKO_B_ARRAY          dq  7.2,    7.8,    6.3,    5.4,    6.6
    PASHCHENKO_C_ARRAY          dq  0.5,    4.3,    -7.2,   -3.1,   3.0
    PASHCHENKO_D_ARRAY          dq  5.5,    4.0,    -3.3,   -2.1,   1.7
    
    PASHCHENKO_CONSTANTS_ARRAY  dq  42.0, 2.0, 5.0
    
    PASHCHENKO_TASK             db  "Task is (42 * c - d / 2 + 1) / (a * a - ln(b -  5))", 10, 10, 0
    
    PASHCHENKO_ANSWER           db  "a = %s, b = %s, c = %s, d = %s", 10,
    "Numerator:", 10,
    "1) 42 * c = %s", 10,
    "2) d / 2 = %s", 10,
    "3) 42 * c - d / 2 + 1 = %s", 10,
    "Denumerator:", 10,
    "4) a * a = %s", 10,
    "5) b - 5 = %s", 10,
    "6) ln(b - 5) = %s", 10,
    "7) a * a - ln(b -  5) = %s", 10,
    "Final answer:", 10,
    "(42 * c - d / 2 + 1) / (a * a - ln(b -  5)) = %s", 10, 10, 0
    
    PASHCHENKO_ERROR_ZERO       db  "a = %s, b = %s, c = %s, d = %s", 10,
    "You cannot divide by zero", 10, 10, 0
    
.code
    Main:
        mov edi, 0
        invoke wsprintf, addr BUFFER_OUTPUT, addr PASHCHENKO_TASK
        
        .while edi <= 4
            finit
            ; calculate (42 * c - d / 2 + 1)
            
            ; 1 - calculate (42 * c)
            fld PASHCHENKO_C_ARRAY[8*edi]
            ; st(0) = c
            fld PASHCHENKO_CONSTANTS_ARRAY[0]
            ; st(0) = 42
            ; st(1) = c
            fmulp   st(1), st
            ; st(0) = 42 * c
            fstp ANSWER_ONE
            
            ; 2 - calculate (d / 2)
            fld PASHCHENKO_D_ARRAY[8*edi]
            ; st(0) = d
            fld PASHCHENKO_CONSTANTS_ARRAY[8*1]
            ; st(0) = 2
            ; st(1) = d
            fdiv
            ; st(0) = d / 2
            fstp ANSWER_TWO
            
            ; 3 - calculate (42 * c - d / 2 + 1)
            fld ANSWER_ONE
            ; st(0) = 42 * c
            fld ANSWER_TWO
            ; st(0) = d / 2
            ; st(1) = 42 * c
            fsub
            ; st(0) = 42 * c - d / 2
            fld1
            ; st(0) = 1
            ; st(1) = 42 * c - d / 2
            fadd
            ; st(0) = 42 * c - d / 2 + 1
            fstp ANSWER_THREE
            
            ; calculate (a * a - ln(b -  5))
            
            ; 4 - calculate (a * a)
            fld PASHCHENKO_A_ARRAY[8*edi]
            fld PASHCHENKO_A_ARRAY[8*edi]
            ; st(0) = a
            ; st(1) = a
            fmulp st(1), st
            ; st(0) = a * a
            fstp ANSWER_FOUR
            
            ; 5 - calculate (b - 5)
            fld PASHCHENKO_B_ARRAY[8*edi]
            ; st(0) = b
            fld PASHCHENKO_CONSTANTS_ARRAY[8*2]
            ; st(0) = 5
            ; st(1) = b
            fsub
            ; st(0) = b - 5
            fstp ANSWER_FIVE
            
            ; 6 - calculate ln(b - 5)
            fldln2
            ; st(0) = ln(2)
            fld ANSWER_FIVE
            ; st(0) = b - 5
            ; st(1) = ln2
            fyl2x
            ; st(0) = log2(b - 5) * ln2 = ln(b - 5)
            fstp ANSWER_SIX
            
            ; 7 - calculate (a * a - ln(b - 5))
            fld ANSWER_FOUR
            ; st(0) = a * a
            fld ANSWER_SIX
            ; st(0) = ln(b - 5)
            ; st(1) = a * a
            fsub
            ; st(0) = a * a - ln(b - 5)
            fstp ANSWER_SEVEN
            
            ; 8 - calculate final answer
            fld ANSWER_THREE
            ; st(0) = 42 * c - d / 2 + 1
            fld ANSWER_SEVEN
            ; st(0) = a * a - ln(b - 5)
            ; st(1) = 42 * c - d / 2 + 1
            fdiv
            ; st(0) = (42 * c - d / 2 + 1) / (a * a - ln(b -  5))
            fstp ANSWER_EIGHT
            
            invoke FloatToStr2, PASHCHENKO_D_ARRAY[8*edi], addr STRING_D
            invoke FloatToStr2, PASHCHENKO_C_ARRAY[8*edi], addr STRING_C
            invoke FloatToStr2, PASHCHENKO_B_ARRAY[8*edi], addr STRING_B
            invoke FloatToStr2, PASHCHENKO_A_ARRAY[8*edi], addr STRING_A
            
            invoke FloatToStr, ANSWER_ONE, addr STRING_ANSWER_ONE
            invoke FloatToStr, ANSWER_TWO, addr STRING_ANSWER_TWO
            invoke FloatToStr, ANSWER_THREE, addr STRING_ANSWER_THREE
            invoke FloatToStr, ANSWER_FOUR, addr STRING_ANSWER_FOUR
            invoke FloatToStr, ANSWER_FIVE, addr STRING_ANSWER_FIVE
            invoke FloatToStr, ANSWER_SIX, addr STRING_ANSWER_SIX
            invoke FloatToStr, ANSWER_SEVEN, addr STRING_ANSWER_SEVEN
            invoke FloatToStr, ANSWER_EIGHT, addr STRING_ANSWER_EIGHT
            
            invoke wsprintf, addr BUFFER, addr PASHCHENKO_ANSWER,
            addr STRING_A,
            addr STRING_B,
            addr STRING_C,
            addr STRING_D,
            addr STRING_ANSWER_ONE,
            addr STRING_ANSWER_TWO,
            addr STRING_ANSWER_THREE,
            addr STRING_ANSWER_FOUR,
            addr STRING_ANSWER_FIVE,
            addr STRING_ANSWER_SIX,
            addr STRING_ANSWER_SEVEN,
            addr STRING_ANSWER_EIGHT
            
            invoke szCatStr, addr BUFFER_OUTPUT, addr BUFFER
            inc edi
        .endw
        invoke MessageBox, 0, addr BUFFER_OUTPUT, addr PASHCHENKO_NAME, 0
        invoke ExitProcess, 0
        
    end Main