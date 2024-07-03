{2. Definir un programa que genere un archivo con registros de longitud fija conteniendo
información de asistentes a un congreso a partir de la información obtenida por
teclado. Se deberá almacenar la siguiente información: nro de asistente, apellido y
nombre, email, teléfono y D.N.I. Implementar un procedimiento que, a partir del
archivo de datos generado, elimine de forma lógica todos los asistentes con nro de
asistente inferior a 1000.
Para ello se podrá utilizar algún carácter especial situándolo delante de algún campo
String a su elección. Ejemplo: ‘@Saldaño’.}
program e2p3;
const
	fin = 1000;
	valorAlto = 9999;
type
	cadena30 = string[30];
	
	asistente = record
		nroAsistente:integer;
		apeYnom:cadena30;
		email:cadena30;
		telefono:cadena30;
		DNI:cadena30;
	end;
	
	archivo = file of asistente;
//----------- FIN DEL TYPE
// CARGAR DEL ARCHIVO
procedure cargarArchivo (var arch: archivo);	
var
	i : integer;
	dato: asistente;
begin
	rewrite(arch);
	for i := 1 to 4 do begin
		writeln('---------------');
		writeln('Ingrese numero de asistente');
		readln(dato.nroAsistente);
		writeln('Ingrese apellido y nombre');
		readln(dato.apeYnom);
		writeln('Ingrese DNI');
		readln(dato.DNI);
		writeln('Ingrese mail');
		readln(dato.email);
		writeln('Ingrese telefono');
		readln(dato.telefono);
		write(arch,dato);
	end;
	close(arch);
end;

//LECTURA
procedure leer (var arch: archivo; var dato: asistente);
begin
	if (not eof(archivo)) then
		read(archivo,dato)
	else
		dato.nroAsistente := valorAlto;
end;

procedure eliminarRegistro(var arch:archivo);
var
	dato:asistente;
begin
	reset(arch);
	leer (arch, dato); //para buscar el fin de archivo sin importar si está ordenado o no
	while(dato.nroAsistente <> valorAlto) do begin
		if (dato.nroAsistente < fin) then begin //busca los menores a mil
			dato.apeYnom:= '@'+ dato.apeYnom; //concatenacion de @ en el apellido para marcar borrado logico
			seek(arch, filePos(arch)-1); // me ubico en la posicion correspondiente
			write(arch,dato); //actualizo el dato pq modifico con el @
		leer (arch, dato); 
	end;
	close(arch.nroAsistente);
end;

procedure imprimir(var a : archivo);
var
	dato : asistente; 
begin
	reset(a);
	leer(a,dato);
	while (dato.nroAsistente <> valorAlto) do begin
		writeln('apellido y nombre del asistente : ', dato.apeYnom);
		writeln('numero del asistente: ', dato.nroAsistente);
		leer(a,dato);
    end; 
	close(a);
end; 

var
	arch: archivo; dato: asistente;
begin
	//assign(arch,'archivo'); // en el de assign(arch,'C:\Users\Usuario\Documents\INFORMATICA\FOD\Practica 3\archivo'); // para no volver a crear el archivo y probar
	cargarArchivo(arch);
	leer (arch, dato);
	eliminarRegistro(arch);
	imprimir(arch);
end.
