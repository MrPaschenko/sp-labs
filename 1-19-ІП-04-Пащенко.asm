.386

.model flat, stdcall
    option casemap :none
    include \masm32\include\masm32rt.inc

.data?
    buff db 128 dup(?)
    buffD db 32 dup(?)
    buffE db 32 dup(?)
    buffF db 32 dup(?)
    buffMinusD db 32 dup(?)
    buffMinusE db 32 dup(?)
    buffMinusF db 32 dup(?)

.data
    MsgBoxCaption db "Лабораторна робота 1", 0
    form db "A = %d", 10, "B = %d", 10, "C = %d", 10, 10,
    "-A = %d", 10, "-B = %d", 10, "-C = %d", 10, 10,
    "D = %s", 10, "E = %s", 10, "F = %s", 10, 10,
    "-D = %s", 10, "-E = %s", 10, "-F = %s",
    0
 
    PASHCHENKO_DDMMYYYY_ASCII db "16122002"
    PASHCHENKO_A_BYTE db 16
    PASHCHENKO_MINUS_A_BYTE db -16

    PASHCHENKO_A_WORD dw 16
    PASHCHENKO_B_WORD dw 1612
    PASHCHENKO_MINUS_A_WORD dw -16
    PASHCHENKO_MINUS_B_WORD dw -1612

    PASHCHENKO_A_SHORTINT dd 16
    PASHCHENKO_B_SHORTINT dd 1612
    PASHCHENKO_C_SHORTINT dd 16122002
    PASHCHENKO_MINUS_A_SHORTINT dd -16
    PASHCHENKO_MINUS_B_SHORTINT dd -1612
    PASHCHENKO_MINUS_C_SHORTINT dd -16122002

    PASHCHENKO_A_LONGINT dq 16
    PASHCHENKO_B_LONGINT dq 1612
    PASHCHENKO_C_LONGINT dq 16122002
    PASHCHENKO_MINUS_A_LONGINT dq -16
    PASHCHENKO_MINUS_B_LONGINT dq -1612
    PASHCHENKO_MINUS_C_LONGINT dq -16122002

    PASHCHENKO_D_SINGLE dq 0.038
    PASHCHENKO_MINUS_D_SINGLE dq -0.038

    PASHCHENKO_E_DOUBLE dq 3.847
    PASHCHENKO_MINUS_E_DOUBLE dq -3.847

    PASHCHENKO_F_EXTENDED dq 38477.332
    PASHCHENKO_MINUS_F_EXTENDED dq -38477.332

.code
    Main:
        invoke FloatToStr2, PASHCHENKO_D_SINGLE, addr buffD
        invoke FloatToStr, PASHCHENKO_E_DOUBLE, addr buffE
        invoke FloatToStr, PASHCHENKO_F_EXTENDED, addr buffF
        invoke FloatToStr2, PASHCHENKO_MINUS_D_SINGLE, addr buffMinusD
        invoke FloatToStr, PASHCHENKO_MINUS_E_DOUBLE, addr buffMinusE
        invoke FloatToStr, PASHCHENKO_MINUS_F_EXTENDED, addr buffMinusF
        invoke wsprintf, addr buff, addr form, 
        PASHCHENKO_A_SHORTINT, PASHCHENKO_B_SHORTINT, PASHCHENKO_C_SHORTINT,
        PASHCHENKO_MINUS_A_SHORTINT, PASHCHENKO_MINUS_B_SHORTINT, PASHCHENKO_MINUS_C_SHORTINT,
        addr buffD, addr buffE, addr buffF,
        addr buffMinusD, addr buffMinusE, addr buffMinusF
        
        invoke MessageBox, 0, addr buff, addr MsgBoxCaption, 0
        invoke ExitProcess, 0
    end Main
