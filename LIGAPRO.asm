.data
titulo: .asciiz "-----LIGA PRO-----\n"
menu: .asciiz "1. Ver tabla de posiciones\n2. Ingresar partido\n3. Mostrar TOP3\n4. Salir\n"
ingreso: .asciiz "Ingrese una opcion: "
salida: .asciiz "Saliendo del programa...\n"
o1: .asciiz "Tabla de la Liga Pro\n"
o2: .asciiz "Ingrese un partido: \n"
o3: .asciiz "TOP 3\n"
err: .asciiz "Elija una opcion entre 1 y 4!\n"

coma: .asciiz ","
salto: .asciiz "\n"
archivo: 
	.asciiz "C:\\Users\\Leonardo\\Documents\\JoseEspol\\OrganizacionComputadores\\ProyectoOrganizacion\\TablaIni.txt"
	.align 2

lugar1: .space 32
lugar2: .space 32
lugar3: .space 32
lugar4: .space 32
lugar5: .space 32
lugar6: .space 32
lugar7: .space 32
lugar8: .space 32
lugar9: .space 32
lugar10: .space 32
lugar11: .space 32
lugar12: .space 32
lugar13: .space 32
lugar14: .space 32
lugar15: .space 32
lugar16: .space 32
 
arrayEquipos:
	.word lugar1, lugar2, lugar3, lugar4, lugar5, lugar6, lugar7, lugar8, lugar9, lugar10, lugar11, lugar12, lugar13, lugar14, lugar15, lugar16

newBuffer: .space 512 
buffer: .space 128
primerLugarTabla: .space 128

.globl main

.text
#Main

main: 
	jal cargar_archivo		#Llama a la funcion que carga el archivo en memoria
	jal separarValores 		#Llama a la funcion que carga los datos en el array
	
	
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
		
		jal separarValores
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

separarValores:

	addi $sp, $sp, -12
	sw $a0, 0($sp)
	sw $s0, 4($sp)
	sw $ra, 8($sp)
	
	la $t0, buffer		#muevo la direccion de mis datos a t0 para poder usarlo
	addi $t0, $t0, 39	#Sumo 38 que es el total de bytes de la primera linea y asi saltarmela
	#guardando el salto de linea
	la $a0, salto
	lb $a0, ($a0)
	move $t1, $a0  		# $t1 = "\n"
	#guardando la coma
	la $a0, coma
	lb $a0, ($a0)
	move $t2, $a0 		#t2 = ","
	
	addi $t6, $t6, 0	#Este valor es un contador de bytes leidos (Inicia en 0)
	
	addi $t3, $t3, 0 	#$t3 = 0 y es usado para contar la cantidad de comas
	addi $t4, $t4, 0	#$t4 = 0 y es usado para contar los saltos de linea
	obtenerEquipos:		#Loop que lee el archivo cargado en memoria y pregunta por comas y saltos de linea
		
		lbu $t5, 0($t0)			#asignando caracteres a t5 para leerlos
		li $v0, 11
		move $a0, $t5
		syscall
		
		#beq $t5, $t2, hayComa			#if(t0[i] = ",") go to hayComa
		beq $t4, 16, return			#Si termina de leer las 16 filas retorna
		beq $t5, $t1, haySalto 			#if(t0[i] ="\n") go to haySalto
		#Si no hay salto, guardo las lineas
		lw $t7, arrayEquipos($t8)   		#Gyardo la primera direccion de array en t7
		add $t7, $t7, $t6			#Sumo la direccion del espacio actual de array con los bytes leidos y lo guardo en $t7
		sb $t5, 0($t7)				#Guardo el byte leido en la posicion obetenido del t7 array[0][0] = t5
		#sb $t5, lugar1($t6)
		#sb $t5, primerLugarTabla($t6)
		addi $t6, $t6, 1		#Sumo el contador de bytes leidos en 1 (t6++)
		#beq $t3, 1, obtenerEquipos	#Si el numero de comas no es igual a 1, entonces no estamos en puntos	
		addi $t0, $t0, 1    		#Sumo en 1 la direccion de memoria de t0
		j obtenerEquipos

				
		haySalto:
			 
			lw $t7, arrayEquipos($t8) 	#guardo la direccion de memoria del primer lugar del array en $t7
			addi $t4, $t4, 1		#Sumo en 1 el numero de lineas t4++
			li $t3, 0			#Seteo en 0 la cantidad de comas cuando encontramos un salto de linea
			li $t6, 0			#Seteo en 0 la cantidad de bytes contados
			addi $t0, $t0, 1    		#Sumo en 1 la direccion de memoria de t0
			addi $t8, $t8, 4
			j obtenerEquipos
	
	return:
		li $v0, 4
		la $a0, lugar2
		syscall 
		
		
		
		lw $a0, 0($sp)
		lw $s0, 4($sp)
		lw $ra, 8($sp)
		addi $sp, $sp, 12
		jr $ra

	
ordenarEquipos:
	addi $sp, $sp, -12
	sw $a0, 0($sp)
	sw $s0, 4($sp)
	sw $ra, 8($sp)	
	
	#li $t1, $t1, 0
	la $t0, arrayEquipos($t1)
	
	
	
	
	lw $t1, 0($t0)
		  

	 	noHayComa:
			lbu $t5, 0($t0)			#asignando caracteres a t5 para leerlos
			beq $t3, 1, obtenerEquipos	#Si el numero de comas no es igual a 1, entonces no estamos en puntos
			
			addi $t0, $t0,1    		#Sumo en 1 la direccion de memoria de t0
			
		hayComa:
			addi $t3, $t3, 1		#Sumo en 1 la cantidad de comas 
			addi $t0, $t0, 1		#Avanzo al siguiente caracter 
			beq  $t3, 1, puntoDeEquipo	#Si estoy en la coma 1 los siguientes caracteres seran los puntos de cada equipo
			
			puntoDeEquipo:
				sb $t0, primerLugarTabla
				addi $t0, $t0, 1
				
				li $v0, 4
				la $a0, 0($t0)
				syscall
				
				j obtenerEquipos
	
	lw $a0, 0($sp)
	lw $s0, 4($sp)
	lw $ra, 8($sp)	
	addi $sp, $sp, 12