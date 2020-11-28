.data
titulo: .asciiz "-----LIGA PRO-----\n"
menu: .asciiz "1. Ver tabla de posiciones\n2. Ingresar partido\n3. Mostrar TOP3\n4. Salir\n"
ingreso: .asciiz "Ingrese una opcion: "
salida: .asciiz "Saliendo del programa...\n"
o1: .asciiz "Tabla de la Liga Pro\n"
o2: .asciiz "***INGRESE UN PARTIDO***\n"
o3: .asciiz "TOP 3\n"
err: .asciiz "Elija una opcion entre 1 y 4!\n"
pedirequipo1: .asciiz "Ingrese el nombre del Equipo 1: "
goles1: .asciiz "Ingrese la cantidad de goles del Equipo 1: "
goles2: .asciiz "Ingrese la cantidad de goles del Equipo 2: "
pedirequipo2: .asciiz "Ingrese el nombre del Equipo 2: "
nExiste: .asciiz "El equipo ingresado no existe en el arreglo.\n"

coma: .asciiz ","
salto: .asciiz "\n"
archivo: 
	.asciiz "D:\\Carlos\\Documents\\8VO SEMESTRE ESPOL\\PROYECTO OC\\ProyectoOrganizacion\\TablaIni.txt"
	.align 2

lugar1: .space 64
lugar2: .space 64
lugar3: .space 64
lugar4: .space 64
lugar5: .space 64
lugar6: .space 64
lugar7: .space 64
lugar8: .space 64
lugar9: .space 64
lugar10: .space 64
lugar11: .space 64
lugar12: .space 64
lugar13: .space 64
lugar14: .space 64
lugar15: .space 64
lugar16: .space 64
 
arrayEquipos:
	.word lugar1, lugar2, lugar3, lugar4, lugar5, lugar6, lugar7, lugar8, lugar9, lugar10, lugar11, lugar12, lugar13, lugar14, lugar15, lugar16

newBuffer: .space 512 
buffer: .space 128
primerLugarTabla: .space 128

temp: .space 32
temp2: .space 32

#EQUIPOS
e1: .asciiz "Aucas"
e2: .asciiz "Barcelona"
e3: .asciiz "D. Cuenca"
e4: .asciiz "Delfin"
e5: .asciiz "El Nacional"
e6: .asciiz "Emelec"
e7: .asciiz "Guayaquil City"
e8: .asciiz "Ind. del Valle"
e9: .asciiz "LDU Quito"
e10: .asciiz "Liga (P)"
e11: .asciiz "Macara" 
e12: .asciiz "Mushuc Runa"
e13: .asciiz "Olmedo"
e14: .asciiz "Orense"
e15: .asciiz "Tecnico Univ."
e16: .asciiz "U.Catolica"

arreglo_equipos:
	.word e1, e2, e3, e4, e5, e6, e7, e8, e9, e10, e11, e12, e13, e14, e15, e16
	.word 0


.globl main

.text
#Main

main: 
	jal cargar_archivo		#Llama a la funcion que carga el archivo en memoria
	jal separarValores 		#Llama a la funcion que carga los datos en el array

iniciomenu:
	
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
	
		j iniciomenu
	
	opcion2: 
		#TITULO
		li $v0, 4
		la $a0, o2
		syscall
		
		#PIDO EQUIPO 1
		li $v0, 4
		la $a0, pedirequipo1
		syscall
		
		#LEO EL VALOR
		li $v0, 8
		li $a1, 20
		syscall
		
		#MUEVO EL VALOR A $s1
		move $s1, $a0
		
		jal longStr
		move $a2, $v0
		sub $a2, $a2, 1
		
		#Pido la cantidad de los goles del equipo1
		li $v0, 4
		la $a0, goles1
		syscall
		
		#Leo el valor
		li $v0, 5
		syscall
		
		#Muevo el valor $s3
		move $s3, $v0
		
		#Pido el nombre del equipo2
		li $v0, 4
		la $a0, pedirequipo2
		syscall
		
		#Leo el valor
		li $v0, 8
		li $a1, 20
		syscall
		
		#Muevo el valor a $s2
		move $s2, $a0
		
		jal longStr
		move $a3, $v0
		sub $a3, $a3, 1
		
		#Pido la cantidad de los goles del equipo2
		li $v0, 4
		la $a0, goles2
		syscall
		
		#Leo el valor
		li $v0, 5
		syscall
		
		#Muevo el valor a $s4
		move $s4, $v0
		
		jal IndiceEquipo1
		move $s5, $v0
		
		jal IndiceEquipo2
		move $s6, $v0
		
		li $s1, 0
		li $s2, 0
		li $s3, 0
		li $s4, 0
		
		j iniciomenu
	
	opcion3: 
		li $v0, 4
		la $a0, o3
		syscall
		
		j iniciomenu
	
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

    li $t1, 0                #total de lineas
    li $t2, 0                #offset para el array

    for:
        beq $t1, 16, exitLeer        #Si t1 = 16, acabo de leer el archivo
        lw $t0, arrayEquipos($t2)        #Guardo en t0 la direccion del primer elemento del array

        li $v0, 4
        la $a0, ($t0)
        syscall

        li $v0, 4            #Imprimo el salto de linea despues de leer cada linea
        la $a0, salto
        syscall

        addi $t2, $t2, 4
        addi $t1, $t1, 1
        j for

    exitLeer:
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
	
	la $t0, lugar1
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
				
				
#OBTIENE EL INDICE EN LA LISTA DE FILAS DEL EQUIPO 1
#s1 -> equipo1
#a2 -> longStr del equipo1
IndiceEquipo1:

	addi $sp, $sp, -56
	sw $a0, 0($sp)
	sw $a1, 4($sp)
	sw $a2, 8($sp)
	sw $a3, 12($sp)
	sw $t1, 16($sp)
	sw $t2, 20($sp)
	sw $t3, 24($sp)
	sw $t4, 28($sp)
	sw $t5, 32($sp)
	sw $t6, 36($sp)
	sw $t7, 40($sp)
	sw $t8, 44($sp)
	sw $t9, 48($sp)
	sw $ra, 52($sp)
	
	add $t0, $zero, $zero #contador = 0
	add $t2, $zero, $zero #indice
	
	la $t9, coma
	lb $t9, ($t9)
		
	#RECORRER EL ARREGLO DE FILAS
	forModiFila:
		
		li $t6, 0
		slti $t1, $t0, 16
		beq $t1, 0, finfor
		
		sll $t3, $t2, 2
		lw $t4, arrayEquipos($t3)
		
		forBytes:
			lbu $t5, 0($t4)
			beq $t5, $t9, foundComa
	
			sb $t5, temp($t6)
			addi $t4, $t4, 1
			addi $t6, $t6, 1
			
			j forBytes
		
		foundComa:
			
			move $a0, $s1
			la $t8, temp
			move $a1, $t8
			
			jal compararStrings
			
			move $t7, $v0
			beq $t7, 1, lMemoria
			
			addi $t2, $t2, 1
			addi $t0, $t0, 1
			
			j forModiFila
		
		
	finfor:
		li $v0, 4
		la $a0, nExiste
		syscall
		j lMemoria
		
	lMemoria:	
	
		move $v0, $t2
	
		lw $a0, 0($sp)
		lw $a1, 4($sp)
		lw $a2, 8($sp)
		lw $a3, 12($sp)
		lw $t1, 16($sp)
		lw $t2, 20($sp)
		lw $t3, 24($sp)
		lw $t4, 28($sp)
		lw $t5, 32($sp)
		lw $t6, 36($sp)
		lw $t7, 40($sp)
		lw $t8, 44($sp)
		lw $t9, 48($sp)
		lw $ra, 52($sp)
		addi $sp, $sp, 56
		
		jr $ra
		
	
#MODIFICAR LOS DATOS DE UNA FILA, SEGUN EL NOMBRE DEL EQUIPO
#s2 -> equipo2
#$a2 -> longStr equipo2
IndiceEquipo2:

	addi $sp, $sp, -56
	sw $a0, 0($sp)
	sw $a1, 4($sp)
	sw $a2, 8($sp)
	sw $a3, 12($sp)
	sw $t1, 16($sp)
	sw $t2, 20($sp)
	sw $t3, 24($sp)
	sw $t4, 28($sp)
	sw $t5, 32($sp)
	sw $t6, 36($sp)
	sw $t7, 40($sp)
	sw $t8, 44($sp)
	sw $t9, 48($sp)
	sw $ra, 52($sp)
	
	add $t0, $zero, $zero #contador = 0
	add $t2, $zero, $zero #indice
	
	li $t3, 0
	li $t5, 0
	la $t9, coma
	lb $t9, ($t9)
		
	#RECORRER EL ARREGLO DE FILAS
	forModiFila2:
		
		li $t6, 0
		slti $t1, $t0, 16
		beq $t1, 0, finfor2
		
		sll $t3, $t2, 2
		lw $t4, arrayEquipos($t3)
		
		forBytes2:
			lbu $t5, 0($t4)
			beq $t5, $t9, foundComa2
	
			sb $t5, temp2($t6)
			addi $t4, $t4, 1
			addi $t6, $t6, 1
			
			j forBytes2
		
		foundComa2:
			
			move $a0, $s2
			la $t8, temp2
			move $a1, $t8
			move $a2, $a3
			
			jal compararStrings
			
			move $t7, $v0
			beq $t7, 1, lMemoria2
			
			addi $t2, $t2, 1
			addi $t0, $t0, 1
			
			j forModiFila2
		
		
	finfor2:
		li $v0, 4
		la $a0, nExiste
		syscall
		j lMemoria2
		
	lMemoria2:	
	
		move $v0, $t2
	
		lw $a0, 0($sp)
		lw $a1, 4($sp)
		lw $a2, 8($sp)
		lw $a3, 12($sp)
		lw $t1, 16($sp)
		lw $t2, 20($sp)
		lw $t3, 24($sp)
		lw $t4, 28($sp)
		lw $t5, 32($sp)
		lw $t6, 36($sp)
		lw $t7, 40($sp)
		lw $t8, 44($sp)
		lw $t9, 48($sp)
		lw $ra, 52($sp)
		addi $sp, $sp, 56
		
		jr $ra


#Longitud de una cadena de caracteres
#$a0 -> String 
#$v0 -> longitud
longStr:

	addi $sp,$sp,-12
        sw $t0, 0($sp)
        sw $t1, 4($sp)
        sw $ra, 8($sp)
        
        li $t0,0
        
        loopstr:
        
        	add $t1,$a0,$t0
        	lbu $t1,0($t1)
        	beq $t1,0,finlongstr
        	addi $t0,$t0,1
        	j loopstr
        	
        finlongstr:
        
        move $v0,$t0
                
        lw $t0,0($sp)
        lw $t1,4($sp)
        lw $ra, 8($sp)
        addi $sp,$sp,12
        
        jr $ra
        
        
#COMPARAR 2 STRINGS
# a0 -> String1
# a1 -> String2
# a2 -> Longitud string1
# a3 -> longitud string 2
# $v0 -> 1 si son iguales, 0 si no lo son.

compararStrings:

	#Reservar la memoria
 	addi $sp, $sp, -32
 	sw $a0, 0($sp)
 	sw $a1, 4($sp)
	sw $a2, 8($sp)
	sw $t2, 12($sp)
	sw $t3, 16($sp)
 	sw $ra, 20($sp) 
 	sw $t9, 24($sp)
 	sw $t7, 28($sp)

	li $t9, 0
	li $t8, 0
	
	#Loop para comparar 

	slt $t7, $a2, $a3
	slt $s7, $a3, $a3
	beq $t7, 1, noiguales
	beq $s7, 1, noiguales

	loopComparacion:

		beq $t9, $a2, iguales          #Si ya me recorrio $a2, quiere decir que son iguales
		lbu $t2, ($a0) #obtener el prox char de a0
		lbu $t3, ($a1) #obtener el prox char de a1

		bne $t2, $t3, noiguales

		addi $a0, $a0, 1 #Avanzo 1char en a0
		addi $a1, $a1, 1 #Avanzo 1char en a1
		addi $t9, $t9, 1 #Avanzo contador

		j loopComparacion
	
	finComparacion:

 		lw $a0,0($sp)
 		lw $a1,4($sp)
 		lw $a2,8($sp)
 		lw $t2, 12($sp)
		lw $t3, 16($sp)
 		lw $ra, 20($sp) 
 		lw $t9, 24($sp)
 		lw $t7, 28($sp)
 		addi $sp,$sp,32
 		jr $ra
 	
	#No son iguales
	noiguales:

		li $v0,0
		j finComparacion

	#Son iguales
	iguales:
		li $v0,1
		j finComparacion
