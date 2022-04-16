.syntax unified
.thumb
.text

@ Simbolos exportados
.global asm_svc
.global asm_sum
.global asm_zeros
.global asm_productoEscalar32
.global asm_productoEscalar16
.global asm_productoEscalar12

@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
@ Prototipo en "C":
@   void asm_svc (void)
@
.thumb_func
    asm_svc:
        svc 0
        bx lr


@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
@ Prototipo en "C":
@   uint32_t asmSum (uint32_t firstOperand, uint32_t secondOperand)
@
@ Parametros recibidos:
@   r0: firstOperand
@   r1: secondOperand
@
@ Valor de retorno:
@   r0: resultado de la suma de firstOperand y secondOperand
@
.thumb_func
    asm_sum:
        add r0, r1  @ r0 = r0 + r1
        bx lr       @ vuelve adonde fue llamada (especificamente, si "pc"
                    @ es la direccion, en el codigo del programa, de la
                    @ instruccion "bl asm_sum" usada para saltar a
                    @ esta funcion, entonces "lr" contiene ese "pc" + 4).
                    @ el valor de retorno debe quedar en el registro r0.
                    @ En este caso, r0 es el resultado de r0 + r1.

        @ Otras alternativas para el retorno
        @ mov pc,lr
        @ bx lr
        @ push {lr} ... pop {pc}


@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
@ Prototipo en "C":
@   void asm_zeros(uint32_t * vector, uint32_t longitud);
@
@ Parametros recibidos:
@   r0: vector
@   r1: longitud
@
.thumb_func
	asm_zeros:
		mov r2, 0				@ r2 = 0;
	.asm_zeros_for:				@ etiqueta del loop.
		str r2, [r0], #4		@ *r0 = r2; r0 += 4;
		subs r1, 1				@ r1 -= 1;
		bne .asm_zeros_for		@ salto a la etiqueta si el resultado de la resta no es 0.
		bx lr					@ salgo de la función.


@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
@ Prototipo en "C":
@   void asm_productoEscalar32(uint32_t * vectorIn, uint32_t * vectorOut, uint32_t longitud, uint32_t escalar);
@
@ Parametros recibidos:
@   r0: vectorIn
@   r1: vectorOut
@	r2: longitud
@	r3: escalar
@
.thumb_func
	asm_productoEscalar32:
		push {r4-r5}					@ guardo r4 y r5 en el stack para usarlos.
	.asm_productoEscalar32_for:			@ etiqueta del loop.
		ldr r4, [r0], #4				@ r4 = *r0; r0 +=4;
		mul r5, r4, r3 					@ r5 = r4 * r3;
		str r5, [r1], #4				@ *r1 = r5; r1 += 4
		subs r2, 1						@ r2 -= 1;
		bne .asm_productoEscalar32_for	@ salto a la etiqueta si el resultado no es 0.
		pop {r4-r5}						@ restauro el valor de r4.
		bx lr							@ salgo de la función.


@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
@ Prototipo en "C":
@   void asm_productoEscalar16(uint16_t * vectorIn, uint16_t * vectorOut, uint32_t longitud, uint16_t escalar);
@
@ Parametros recibidos:
@   r0: vectorIn
@   r1: vectorOut
@	r2: longitud
@	r3: escalar
@
.thumb_func
	asm_productoEscalar16:
		push {r4-r5}					@ guardo r4 y r5 en el stack para usarlos.
	.asm_productoEscalar16_for:			@ etiqueta del loop.
		ldrh r4, [r0], #2				@ r4 = *r0; r0 +=4;
		mul r5, r4, r3 					@ r5 = r4 * r3;
		strh r5, [r1], #2				@ *r1 = r5; r1 += 4
		subs r2, 1						@ r2 -= 1;
		bne .asm_productoEscalar16_for	@ salto a la etiqueta si el resultado no es 0.
		pop {r4-r5}						@ restauro el valor de r4.
		bx lr							@ salgo de la función.


@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
@ Prototipo en "C":
@ void productoEscalar12(uint16_t * vectorIn, uint16_t * vectorOut, uint32_t longitud, uint16_t escalar);
@
@ Parametros recibidos:
@   r0: vectorIn
@   r1: vectorOut
@	r2: longitud
@	r3: escalar
@
.thumb_func
	asm_productoEscalar12:
		bx lr
