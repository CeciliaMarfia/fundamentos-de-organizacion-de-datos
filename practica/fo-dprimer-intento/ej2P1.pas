{2. Realizar un algoritmo, que utilizando el archivo de números enteros no ordenados
creados en el ejercicio 1, informe por pantalla cantidad de números menores a 1500 y el
promedio de los números ingresados. El nombre del archivo a procesar debe ser
proporcionado por el usuario una única vez. Además, el algoritmo deberá listar el
contenido del archivo en pantalla.}
program e2P1;
const
	fin = 30000; //La carga finaliza cuando se ingrese el número 30000
	numRef = 1500;
type
	archivo_enteros = file of integer; // defino un tipo de archivo de enteros que reside en la mem secundaria y es administ por el SO
{--FIN DEL TYPE--}

procedure cargarDatos(var arch_logico:archivo_enteros);
//lectura de números enteros para ingresar datos al archivo
var 
	num:integer;
begin
	writeln('Ingrese un número:');
	readln(num);
	while (num <> fin) do begin
		write (arch_logico, num); // escribo dato al archivo	
		writeln('Ingrese un número:');
		readln(num);
	end;
end;

function calcularPromedio(suma, cant: integer) : real;
begin
	calcularPromedio := suma/cant;
end;

procedure recorrerArchivo(var arch_logico: archivo_enteros);
var
	num, cantNum,sumaNum: integer;
begin
	cantNum:=0;
	sumaNum:=0;
	reset(arch_logico); //como el archivo ya está creado utilizo reset
	// Recorre el archivo
	while not eof(arch_logico) do begin // Mientras no llegue al final del archivo
		read(arch_logico, num); // Lee un elemento
		write(num); // Imprime el elemento en pantalla
		writeln;
		sumaNum:=sumaNum+num;
		if (num<numRef) then
			cantNum:=cantNum+1;
	end;
	writeln('Cantidad de números menores a ',numRef,': ',cantNum);
	writeln('Promedio de los números ingresados: ',calcularPromedio(sumaNum,filesize(arch_logico)):3:3);
end;
	
{--PROGRAMA PRINCIPAL---}

var
	archivo_logico: archivo_enteros; // el archivo lógico que es utilizado desde el algoritmo cuando este necesita operar con un archivo genera conexion con el SO
	nombre_fisico,arch_a_procesar: string[15]; // Lo proporciona el usuario desde teclado
begin
	
	// Ingreso del nombre fisico del archivo
	writeln('Ingrese el nombre del archivo:');
	readln(nombre_fisico);
	
	//correspondencia archivo lógico - archivo físico:
	Assign(archivo_logico, nombre_fisico);
	
	//Apertura y creación de archivos
	rewrite(archivo_logico); // como el archivo aun no fue creado lo creo acá y ya puedo escribirle información
	
	cargarDatos(archivo_logico);
	
	// Cierre del archivo
	close (archivo_logico);
	
	writeln('Ingrese el nombre del archivo a procesar');
	readln(arch_a_procesar);
	if (arch_a_procesar = nombre_fisico) then
		recorrerArchivo (archivo_logico)
	else
		writeln('El nombre ingresado no coincide con ningun archivo');

end.
