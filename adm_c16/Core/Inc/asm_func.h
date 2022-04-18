#pragma once

#include <stdint.h>


void asm_svc (void);

uint32_t asm_sum (uint32_t firstOperand, uint32_t secondOperand);

/* Ejercicio 1 */
void asm_zeros(uint32_t * vector, uint32_t longitud);


/* Ejercicio 2 */
void asm_productoEscalar32(uint32_t * vectorIn, uint32_t * vectorOut, uint32_t longitud, uint32_t escalar);

/* Ejercicio 3 */
void asm_productoEscalar16(uint16_t * vectorIn, uint16_t * vectorOut, uint32_t longitud, uint16_t escalar);

/* Ejercicio 4 */
void asm_productoEscalar12(uint16_t * vectorIn, uint16_t * vectorOut, uint32_t longitud, uint16_t escalar);

/* Ejercicio 5 */
void asm_filtroVentana10(uint16_t * vectorIn, uint16_t * vectorOut, uint32_t longitudVectorIn);

/* Ejercicio 7 */
int32_t asm_max(int32_t * vectorIn, uint32_t longitud);

/* Ejercicio 8 */
void asm_downsampleM(int32_t * vectorIn, int32_t * vectorOut, uint32_t longitud, uint32_t N);

/* Ejercicio 9 */
void asm_invertir (uint16_t * vector, uint32_t longitud);
