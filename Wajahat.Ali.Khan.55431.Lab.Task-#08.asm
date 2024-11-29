.model small ; Reserve 64kb memory for data and code 

.stack 100h ; Reserve 256 bytes for stack

.data ; Data directive  

    message db "Please select the proper number for the following: $"   
    one db "1. Addition   $"
    two db "2. Subtraction   $"  
    three db "3. Division  $" 
    restriction db "Enter your choice: $"
    number1 db "Enter number 1: $"
    number2 db "Enter number 2: $"
    resultForAddition db "The sum of the above numbers is: $"
    resultForSubtraction db "The subtraction of the above numbers is: $"
    resultForDivision db "The division of the above numbers is: $"
    result db ? ; Store result here

.code ; Code section

; Macros for operations
Addition macro v1, v2
    mov al, v1
    add al, v2
    mov result, al
endm

Subtraction macro v1, v2
    mov al, v1
    sub al, v2
    mov result, al
endm

Division macro v1, v2
    mov al, v1
    mov ah, 0 ; Clear AH for division
    div v2
    mov result, al ; Store quotient in result
endm

main proc ; Main procedure 
    
    mov ax, @data ; Initialize data segment
    mov ds, ax

Start:
    ; Display welcome message
    call NewLine 
    call NewLine
    
    mov dx, offset message
    call print_String
   
    call NewLine 
    call NewLine

    ; Display operations
    mov dx, offset one 
    call print_String
    call NewLine

    mov dx, offset two
    call print_String
    call NewLine

    mov dx, offset three 
    call print_String
    call NewLine
    
    ; Display exit option
    mov dx, offset restriction 
    call print_String
    call NewLine

    ; Get user operation choice
    mov ah, 1
    int 21h
    sub al, '0' ; Convert ASCII to integer
    mov bl, al ; Store choice in BL 

    cmp bl, 4
    je ExitProgram ; Exit if choice is 4

    call NewLine

    ; Determine which prompt to display based on operation
    cmp bl, 1 
    je FirstNumberLabel
    cmp bl, 2 
    je FirstNumberLabel
    cmp bl, 3   
    je FirstNumberLabel
    jmp Start ; Go back to start if invalid option

FirstNumberLabel:
    ; Display "Enter the first number"
    mov dx, offset number1
    call print_String
    
ShowPrompt: 
    call GetNumber
    mov cl, al ; Store first number in CL
    call NewLine

    ; Get number 2 for other operations
    mov dx, offset number2 
    call print_String
  
    call GetNumber
    mov ch, al ; Store second number in CH 
    call NewLine

    ; Perform selected operation
    cmp bl, 1
    je DoAddition
    cmp bl, 2
    je DoSubtraction
    cmp bl, 3
    je DoDivision
    jmp Start ; Go back to start if invalid option  

DoAddition:
    Addition cl, ch
    jmp DisplayResult

DoSubtraction:
    Subtraction cl, ch
    jmp DisplayResult

DoDivision:
    cmp ch, 0 ; Check if dividing by zero
    je DivisionError
    Division cl, ch
    jmp DisplayResult

DivisionError:
    ; Handle division by zero error
    mov dx, offset number2
    call print_String
    ; You could show an error message here as well
    jmp Start

DisplayResult:
    cmp bl, 1
    je ShowAdditionResult
    cmp bl, 2
    je ShowSubtractionResult
    cmp bl, 3
    je ShowDivisionResult
    jmp Start

ShowAdditionResult:
    mov dx, offset resultForAddition 
    jmp PrintResult

ShowSubtractionResult:
    mov dx, offset resultForSubtraction 
    jmp PrintResult

ShowDivisionResult:
    mov dx, offset resultForDivision 
    jmp PrintResult

PrintResult:
    call print_String
    mov al, result
    add al, '0' ; Convert result to ASCII
    mov dl, al
    mov ah, 2
    int 21h

    call NewLine
    jmp Start ; Loop back to the start for another operation

ExitProgram:  
    call NewLine 
    call NewLine

    mov ah, 4Ch
    int 21h
main endp

; Procedure to get a single-digit number from user
GetNumber proc
    mov ah, 1
    int 21h
    sub al, '0' ; Convert ASCII to integer
    ret
GetNumber endp

; Procedure for newline
NewLine proc 
    mov dl, 10
    mov ah, 2
    int 21h

    mov dl, 13
    mov ah, 2
    int 21h
    ret
NewLine endp    

print_String proc  
    mov ah, 9
    int 21h
    ret
print_String endp
    
end main ; End of program
