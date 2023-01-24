.386
.model flat, stdcall
    option casemap :none

public thirdProc
extern PASHCHENKO_A_PUBLIC: qword, PASHCHENKO_B_PUBLIC: qword, ANSWER_FOUR: qword, ANSWER_FIVE: qword, ANSWER_SIX: qword, ANSWER_SEVEN: qword, PASHCHENKO_CONSTANT5: qword


.code
    thirdProc proc
        fld PASHCHENKO_A_PUBLIC
        fld PASHCHENKO_A_PUBLIC
        ; st(0) = a
        ; st(1) = a
        fmulp st(1), st
        ; st(0) = a * a
        fstp ANSWER_FOUR

        fld PASHCHENKO_B_PUBLIC
        ; st(0) = b
        fld PASHCHENKO_CONSTANT5
        ; st(0) = 5
        ; st(1) = b
        fsub
        ; st(0) = b - 5
        fstp ANSWER_FIVE

        fldln2
        ; st(0) = ln(2)
        fld ANSWER_FIVE
        ; st(0) = b - 5
        ; st(1) = ln2
        fyl2x
        ; st(0) = log2(b - 5) * ln2 = ln(b - 5)
        fstp ANSWER_SIX

        fld ANSWER_FOUR
        ; st(0) = a * a
        fld ANSWER_SIX
        ; st(0) = ln(b - 5)
        ; st(1) = a * a
        fsub
        ; st(0) = a * a - ln(b - 5)
        fstp ANSWER_SEVEN
        
        ret
    thirdProc endp
end