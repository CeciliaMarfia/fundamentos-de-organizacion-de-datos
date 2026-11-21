{1. Realizar un algoritmo que cree un archivo de números enteros no ordenados y permita
incorporar datos al archivo. Los números son ingresados desde teclado. El nombre del
archivo debe ser proporcionado por el usuario desde teclado. La carga finaliza cuando
se ingrese el número 30000, que no debe incorporarse al archivo.}
program e1P1;
const
	fin = 30000; //La carga finaliza cuando se ingrese el número 30000
type
	archivo_enteros = file of integer; // defino un tipo de archivo de enteros que reside en la mem secundaria y es administ por el SO
{--PROGRAMA PRINCIPAL---}

var
	archivo_logico: archivo_enteros; // el archivo lógico que es utilizado desde el algoritmo cuando este necesita operar con un archivo genera conexion con el SO
	nombre_fisico: string[15]; // Lo proporciona el usuario desde teclado
	num: integer;
begin
	// Ingreso del nombre fisico del archivo
	writeln('Ingrese el nombre del archivo:');
	readln(nombre_fisico);
	
	//correspondencia archivo lógico - archivo físico:
	Assign(archivo_logico, nombre_fisico);
	
	//Apertura y creación de archivos
	rewrite(archivo_logico); // como el archivo aun no fue creado lo creo acá y ya puedo escribirle información
	
	//lectura de números enteros para ingresar datos al archivo
	writeln('Ingrese un número:');
	readln(num);
	while (num <> 30000) do begin
		write (archivo_logico, num); // escribo dato al archivo
		writeln('Ingrese un número:');
		readln(num);
	end;
	
	// Cierre del archivo
	close (archivo_logico);
end.
