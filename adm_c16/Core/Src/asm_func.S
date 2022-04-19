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
.global asm_filtroVentana10
.global asm_pack32to16
.global asm_max
.global asm_downsampleM
.global asm_invertir

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
		ldrh r4, [r0], #2				@ r4 = *r0; r0 +=2;
		mul r5, r4, r3 					@ r5 = r4 * r3;
		strh r5, [r1], #2				@ *r1 = r5; r1 += 2
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
		push {r4-r5}					@ guardo r4 y r5 en el stack para usarlos.
	.asm_productoEscalar12_for:			@ etiqueta del loop.
		ldrh r4, [r0], #2				@ r4 = *r0; r0 +=2;
		mul r5, r4, r3 					@ r5 = r4 * r3;
		usat r5, 12, r5					@ saturo r5 hasta un máximo de 12 bits.
		strh r5, [r1], #2				@ *r1 = r5; r1 += 2
		subs r2, 1						@ r2 -= 1;
		bne .asm_productoEscalar12_for	@ salto a la etiqueta si el resultado no es 0.
		pop {r4-r5}						@ restauro el valor de r4 y r5.
		bx lr							@ salgo de la función.

@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
@ Prototipo en "C":
@ void asm_filtroVentana10(uint16_t * vectorIn, uint16_t * vectorOut, uint32_t longitudVectorIn);
@
@ Parametros recibidos:
@   r0: vectorIn
@   r1: vectorOut
@	r2: longitudVectorIn
@
@ Registros usados:
@ 	r3: promedio.
@	r4: n_filtro.
@	r5: sumatoria.
@ 	r6: dirección de memoria del final de vectorIn.
@ 	r7: dirección de memoria inicial del vectorIn.
@	r8: iterador sobre n_filtro.
@	r9: aux
@
.thumb_func
	asm_filtroVentana10:
		push {r4-r9}							@ guardo los valores de r4, r5, r6, r7, r8 y r9 para usarlos.

		mov	r3, #2								@ r3 = 2;
		mul r5, r3, r2							@ r5 = 2*longitud;
		add r6, r0, r5 							@ r6 = r0 + r5; En r6 queda la dirección de memoria del final del vector.

		mov r4, #10								@ r4 = 10;
		mov r5, #0								@ r5 = 0;
		mov r7, r0								@ r7 = r0; Perservo la dirección de memoria inicial del vector.
		mov r8, r4								@ r8 = 10;

	.asm_filtroVentana10_loop_externo:


		.asm_filtroVentana10_loop_interno:

			cmp r0, r6								@ comparo si se llegó a sobrepasar el vector.

			ite mi
			ldrhmi r9, [r0]							@ si r6 >= r0, r9 = *r0;
			movpl r9, #0							@ si r6 < r0, r9 = 0;

			add r5, r9								@ r5 += r9 //sumatoria += vectorIn[i]
			add r0, #2

			subs r8, #1								@ r8 -= 1;
			bne .asm_filtroVentana10_loop_interno

		udiv r3, r5, r4							@ r3 = r5 / r4; //promedio = sumatoria / n_filtro;
		strh r3, [r1], #2						@ *r1 = r3; r1 += 4; //Guardo el promedio el vectorOut[i].
		mov r5, #0								@ r5 = 0; //Limpio el registro de sumatoria.
		add r7, #2								@ r0 += 2; //Avanzo dos espacios r7.
		mov r0, r7								@ r0 = r7;
		mov r8, #10								@ r8 = 10; //Restauro el valor de r8 para volver a iterar.
		subs r2, #1								@ r2 -= 1;
		bne .asm_filtroVentana10_loop_externo

		pop {r4-r9}								@ restauro el valor de r4, r5, r6, r7, r8 y r9.
		bx lr									@ salgo de la función.


@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
@ Prototipo en "C":
@ void asm_pack32to16(int32_t * vectorIn, int16_t *vectorOut, uint32_t longitud);
@
@ Parametros recibidos:
@   r0: vectorIn
@   r1: vectorOut
@	r2: longitud
@
@ Registros usados:
@ 	r3: aux
@
.thumb_func
	asm_pack32to16:
		push {r4}						@ guardo r4 en el stack para usarlo.
	.asm_pack32to16_loop:
		ldr r4, [r0], #4				@ r4 = *r0; r0 += 4;
		asr r3, r4, 16					@ r3 = r4 >> 16;
		strh r3, [r1], #2				@ *r1 = r3; r1 += 2;
		subs r2, #1						@ r2 -= 1;
		bne .asm_pack32to16_loop		@ salto a la etiqueta si el resultado no es 0.
		pop {r4}						@ restauro el valor de r4.
		bx lr							@ salgo de la función.


@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
@ Prototipo en "C":
@ int32_t asm_max(int32_t * vectorIn, uint32_t longitud);
@
@ Parametros recibidos:
@   r0: vectorIn
@   r1: longitud
@
.thumb_func
	asm_max:
		mov r2, #-2147483648	@ almaceno el número más pequeño int32 en r2.
		push {r4-r5}			@ guardo r4 y r5 en el stack para usarlos.
		mov r5, #0				@ *r5 = 0;
	.asm_max_loop:				@ etiqueta del loop.
		ldr r3, [r0], #4		@ r3 = *r0; r0 +=4;
		cmp r2, r3				@ comparo r2 con r3.
		bgt .no_seleccionar_max	@ si la comparación resulta en Z = 0, N = V, voy a la etiqueta.
	.seleccionar_max:
		mov r2, r3				@ guardo el valor máximo en r2. r2 = r3;
		mov r4, r5				@ guardo el valor de la posición máxima en r4. r4 = r5;
	.no_seleccionar_max:
		add r5, #1				@ *r5 += 1;
		subs r1, #1				@ r1 -= 1;
		bne .asm_max_loop		@ salto a la etiqueta si el resultado no es 0.
		mov r0, r4				@ almaceno el valor de r4 en r0 para devolverlo.
		pop {r4-r5}				@ restauro el valor de r4 y r5.
		bx lr					@ salgo de la función.



@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
@ Prototipo en "C":
@ void asm_downsampleM(int32_t * vectorIn, int32_t * vectorOut, uint32_t longitud, uint32_t N);
@
@ Parametros recibidos:
@   r0: vectorIn
@   r1: vectorOut
@ 	r2: longitud
@	r3: N
@
.thumb_func
	asm_downsampleM:
		push {r4-r5}					@ guardo r4 y r5 en el stack para usarlos.
		mov r5, #0						@ r5 = 0;
	.asm_downSampleM_for:				@ etiqueta del loop.
		cmp r5, r3						@ comparo r5 y r3.

		ittte ne						@ If-Then, Si no son iguales se guarda el valor de en vectorOut, sino se guarda 0 en r5.
		ldrne r4, [r0]					@ r4 = *r0; r0 +=4;
		strne r4, [r1], #4				@ *r1 = r4; r1 += 4;
		addne r5, #1					@ r5 += 1;
		moveq r5, #0					@ r5 = 0;

		add r0, #4						@ r0 += 4;
		subs r2, #1						@ r2 -= 1;
		bne .asm_downSampleM_for		@ salto a la etiqueta si el resultado no es 0.

		pop {r4-r5}						@ restauro el valor de r4.
		bx lr							@ salgo de la función.

@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
@ Prototipo en "C":
@ void asm_invertir (uint16_t * vector, uint32_t longitud);
@
@ Parametros recibidos:
@   r0: vector
@   r1: longitud
@
@ Registros usados:
@	r2: aux
@	r3: dirección de memoria del final del vector.
@	r4: mitad del vector.
@	r5: cantidad que hay que sumar a la dirección de memoria para llegar al final del vector.
@	r6: cantidad de bytes en una media palabra.
@	r7: aux2
.thumb_func
	asm_invertir:
		push {r4-r7}					@ guardo r4, r5, r6 y r7 en el stack para usarlo.
		mov r3, r0						@ guardo el inicio del vector en r3.
		asr r4, r1, #1					@ r4 = r1 >> 1; Divide en 2 r1.
		mov	r6, #2						@ r6 = 2;
		sub r1, #1						@ r1 -= 1;
		mul r5, r6, r1					@ r5 = 2*longitud;
		add r3, r5						@ r3 += r5; En r3 queda la dirección de memoria del final del vector.

	.asm_invertir_loop:
		ldrh r2, [r0]					@ r2 = *r0;
		ldrh r7, [r3]					@ r7 = *r3;
		strh r2, [r3], #-2				@ *r3 = r2; r3 -= 4;
		strh r7, [r0], #2				@ *r0 = r7; r0 += 4;

		subs r4, #1						@ r4 -= 1;
		bne .asm_invertir_loop			@ salto a la etiqueta si el resultado no es 0.

		pop {r4-r7}						@ restauro el valor de r4, r5, r6 y r7.
		bx lr							@ salgo de la función.
