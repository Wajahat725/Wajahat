INCLUDE Irvine32.inc

.data

message BYTE "signed Binary Multiplication by using 32-bit!", 0

.code

main PROC

    mov eax, OFFSET message
    call WriteString    ; Display message
 
    mov eax, 0               
    mov ebx, -15             ; Load multiplicand directly into EBX
    mov ecx, 7              ; Load multiplier directly into ECX

    ; Condition if multiplicand (ebx) is negative
    cmp ebx, 0               
    jl negate_multiplicand    ; If EBX is negative, jump to negate it

    multiplicand_skip:
        ; Check if ECX (multiplier) is negative
        cmp ecx, 0               ; Compare ECX with 0
        jl negate_multiplier      ; If ECX is negative, jump to negate it

    multiplier_skiper:
    mov edx, ecx             
    mov ecx, 32              ;loop counter (32 bits)

loop1:
         and edx, 1               ; Check LSB of multiplier
         jz skip_addition         ; If LSB is 0, skip addition
          add eax, ebx            

     skip_addition:
           shr edx, 1               ; Shift multiplier right
           shl ebx, 1               ; Shift multiplicand left

loop loop1       


    ; If the original signs of multiplicand and multiplier were different, negate the result
    cmp ebx, -15             ; Compare original multiplicand with negative value
    jg result    ; If the multiplicand was originally positive, skip negation
    cmp ecx, 7              ; Compare original multiplier with positive value
    jg result    ; If the multiplier was originally positive, skip negation
    neg eax                  ; Negate the result if signs were different

result:
    call DumpRegs            ; Display registers to check result
    exit
main ENDP
END main