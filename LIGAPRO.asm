.data
titulo: .asciiz "-----LIGA PRO-----\n"
menu: .asciiz "1. Ver tabla de posiciones\n2. Ingresar partido\n3. Mostrar TOP3\n4. Salir\n"
ingreso: .asciiz "Ingrese una opcion: "
salida: .asciiz "Saliendo del programa...\n"
o1: .asciiz "Tabla de la Liga Pro\n"
o2: .asciiz "Ingrese un partido: \n"
o3: .asciiz "TOP 3\n"
err: .asciiz "Elija una opcion entre 1 y 4!\n"

archivo: .asciiz "C:\\Users\\Leonardo\\Documents\\JoseEspol\\OrganizacionComputadores\\ProyectoOrganizacion\\TablaIni.txt"

buffer: .space 128


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
	
	jal validarOpcion
	
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
		
		jal leer_archivo
	
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
		
		jal ordenarTabla
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
cargar_archivo:
	addi $sp,$sp,-4
	sw   $s0,0($sp)

	li   $v0, 13       
	la   $a0, archivo   
	li   $a1, 0        
	li   $a2, 0        
	syscall            
	move $s0, $v0     

	#Guarda informacion en el buffer
	li   $v0, 14       
	move $a0, $s0    
	la   $a1, buffer   
	li   $a2,  1820  
	syscall
	
	#Cierra el archivo
	li   $v0, 16       
	move $a0, $s0   
	syscall            

	lw $s0,0($sp)
	addi $sp,$sp,4

	jr $ra
	
leer_archivo:

	addi $sp,$sp,-4
	sw   $s0,0($sp)

	li   $v0, 13       
	la   $a0, archivo   
	li   $a1, 0        
	li   $a2, 0        
	syscall            
	move $s0, $v0     

	#Guarda informacion en el buffer
	li   $v0, 14       
	move $a0, $s0    
	la   $a1, buffer   
	li   $a2,  1820  
	syscall
	
	#Imprime el contenido del archivo
	li $v0, 4
	la, $a0, buffer
	syscall      

	#Cierra el archivo
	li   $v0, 16       
	move $a0, $s0   
	syscall            

	lw $s0,0($sp)
	addi $sp,$sp,4

	jr $ra
	
validarOpcion:
	
	loop:
		move $t1, $zero
		addi $t1, $t1, 4
		
		slti $t2, $t0, 1
		beq $t2, 1, validacion
		
		slt, $t2, $t1, $t0
		beq $t2, 1, validacion
		
		bne $t2, 1, exit_loop
	
	validacion:
		li $v0, 4
		la $a0, err
		syscall
		
		li $v0, 4
		la $a0, ingreso
		syscall
		
		li $v0, 5
		syscall
		
		move $t0, $v0
		
		j loop
		
	exit_loop:
		jr $ra

ordenarTabla:
	sortLoop:

		addi $sp, $sp, -4
		sw $ra, 0($sp)
		jal cargar_archivo
		
		#Imprime el archivo cargado
		li $v0, 4
		la, $a0, buffer
		la $a0, 8($a0)
		syscall
		#Devuelvo los valores originales en los espacios usados
		lw $ra, 0($sp)
		addi $sp, $sp, 4
		jr $ra
	
		
		  

	 
