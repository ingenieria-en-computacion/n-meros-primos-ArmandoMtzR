section .data
    mensaje_entrada db "Ingrese el valor de a: ", 0
    mensaje_nueva_linea db 10, 0
    mensaje_resultado db "Resultado: "

section .bss
    a resb 4      ; Reserva espacio para el valor de a
    d resb 4      ; Reserva espacio para el valor de d

section .text
    global _start

_start:
    ; Imprimir el mensaje de "Ingrese el valor de a"
    mov rax, 1              ; sys_write
    mov rdi, 1              ; STDOUT
    mov rsi, mensaje_entrada ; Dirección del mensaje
    mov rdx, 20             ; Longitud del mensaje
    syscall

    ; Leer el valor de a
    mov rax, 0              ; sys_read
    mov rdi, 0              ; STDIN
    mov rsi, a              ; Dirección donde se almacenará el valor
    mov rdx, 4              ; Leer 4 bytes
    syscall

    ; Convertir a entero (función convertir_string_a_entero)
    mov rsi, a
    call convertir_string_a_entero  ; El número leído se almacena en RAX

    ; Inicializar d en 3
    mov rbx, 3
    mov [d], rbx

comprobar_a_mod_2:
    ; Verificar si a mod 2 == 0
    mov rax, [a]            ; Cargar el valor de a
    xor rdx, rdx            ; Limpiar el resto
    mov rcx, 2              ; Dividir entre 2
    div rcx
    cmp rdx, 0              ; Si el resto es 0, a es divisible entre 2
    je a_divisible_por_2
    jmp no_a_divisible_por_2

a_divisible_por_2:
    ; Si a mod 2 == 0, imprimir "Resultado: a es divisible por 2"
    mov rax, 1
    mov rdi, 1
    mov rsi, mensaje_resultado
    mov rdx, 10
    syscall

    ; Imprimir el valor de a
    mov rdi, 1              ; STDOUT
    mov rsi, a              ; Dirección de a
    mov rdx, 4              ; Tamaño de un entero
    syscall

    mov rax, 60             ; Exit system call
    xor rdi, rdi            ; Exit code 0
    syscall

no_a_divisible_por_2:
    ; Incrementar d si a mod 2 != 0
    mov rax, [d]
    inc rax
    mov [d], rax

comprobar_d_menor_que_a:
    ; Verificar si d < a
    mov rax, [d]
    cmp rax, [a]
    jge fin_programa

    ; Si d < a, verificar si a mod d == 0
    mov rax, [a]
    xor rdx, rdx
    mov rcx, [d]
    div rcx
    cmp rdx, 0
    je salir_del_bucle

    ; Si no es divisible, incrementar d y seguir con el ciclo
    inc qword [d]
    jmp comprobar_d_menor_que_a

salir_del_bucle:
    ; Si a mod d == 0, imprimir "Resultado: a es divisible por d"
    mov rax, 1
    mov rdi, 1
    mov rsi, mensaje_resultado
    mov rdx, 10
    syscall

    ; Imprimir el valor de a
    mov rdi, 1              ; STDOUT
    mov rsi, a              ; Dirección de a
    mov rdx, 4              ; Tamaño de un entero
    syscall

    jmp fin_programa

fin_programa:
    mov rax, 60             ; Exit system call
    xor rdi, rdi            ; Exit code 0
    syscall

; Función convertir_string_a_entero - Convierte cadena a entero
convertir_string_a_entero:
    xor rax, rax            ; Limpiar RAX
    xor rcx, rcx            ; Limpiar RCX
convertir:
    movzx rdx, byte [rsi + rcx]
    cmp dl, 0x0A            ; Comprobar si es el final de la cadena
    je .convertir_hecho
    sub dl, '0'             ; Convertir el carácter a número
    imul rax, rax, 10       ; Multiplicar por 10
    add rax, rdx            ; Sumar el dígito
    inc rcx
    jmp convertir
.convertir_hecho:
    ret


