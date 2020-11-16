.data
titulo: .asciiz "-----LIGA PRO-----\n"
menu: .asciiz "1. Ver tabla de posiciones\n2. Ingresar partido\n3. Mostrar TOP3\n4. Salir\n"
ingreso: .asciiz "Ingrese una opcion: "
salida: .asciiz "Saliendo del programa...\n"
o1: .asciiz "Tabla de la Liga Pro\n"
o2: .asciiz "Ingrese un partido: \n"
o3: .asciiz "TOP 3\n"
err: .asciiz "Elija una opcion entre 1 y 4!\n"

archivo: .asciiz "TablaIni.txt"

.globl main

.text
#Main

main: 
	#mensaje de inicio
	li $v0, 4
	la $a0, titulo
	syscall
	
	#menu de opciones
	li $v0, 4
	la $a0, menu
	syscall
	
	#pedir opcion
	li $v0, 4
	la $a0, ingreso
	syscall
	
	#lee el valor
	li $v0, 5
	syscall
	
	#mueve el valor leido a t0
	move $t0, $v0
	
	#jal validarOpcion
	
	#opci0n 4 = salir
	beq $t0, 4, exit
	
	#opcion 1 = tabla de posiciones
	beq $t0, 1, opcion1
	
	#opcion 2 = ingresar partido
	beq $t0, 2, opcion2
	
	#opcion 3 = TOP 3
	beq $t0, 3, opcion3
	
	
opcion1:
	li $v0, 4
	la $a0, o1
	syscall
	
	j main
	
opcion2: 
	li $v0, 4
	la $a0, o2
	syscall 
	
	j main
	
opcion3: 
	li $v0, 4
	la $a0, o3
	syscall
	
	j main
	
exit: 
	#mensaje de salida
	li $v0, 4
	la $a0, salida
	syscall
	
	#terminar el programa
	li $v0, 10
	syscall
	
#FUNCIONES	
	
validarOpcion:
	
	move $t2, $zero
	addi $t2, $t2, 4
	
	slti $t1, $t0, 1
	beq $t3, 1, error
	
	slt $t1, $t2, $t0
	beq $t3, 1, error

	error:
		li $v0, 4
		la $a0, err
		syscall
			
	jr $ra

	 