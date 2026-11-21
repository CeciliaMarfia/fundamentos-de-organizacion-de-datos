{7)
Realizar un programa que permita:

a. Crear un archivo binario a partir de la información almacenada en un archivo de texto.
El nombre del archivo de texto es: “novelas.txt”

b. Abrir el archivo binario y permitir la actualización del mismo. Se debe poder agregar
una novela y modificar una existente. Las búsquedas se realizan por código de novela.

NOTA: La información en el archivo de texto consiste en: código de novela, nombre,
género y precio de diferentes novelas argentinas. De cada novela se almacena la
información en dos líneas en el archivo de texto. La primera línea contendrá la siguiente
información: código novela, precio, y género, y la segunda línea almacenará el nombre
de la novela.}

program ejercicio7;
type
	cadena30 = string[30];

	novela = record
		cod: integer;
		precio: real;
		genero: cadena30;
		nombre: cadena30;
	end;

	novelas = file of novela;
{-------------fin del type-----------------}
procedure crearArchivo(var arch:novelas);
var
	nombre_fisico:cadena30;
	txt: text;
	nov:novela;
begin
	writeln('Por favor ingrese el nombre del archivo a crear:');
	readln(nombre_fisico);
	assign(arch,nombre_fisico); // Asigna el nombre logico y el fisico
	rewrite(arch); // Crea el archivo binario
	assign(txt, 'novelas.txt');
	reset(txt); // Abre el archivo de texto
	while(not eof(txt)) do begin
		with nov do begin
			read(txt, cod, precio, genero); //o readln?
			read(txt, nombre);
			write(arch, nov); // Escribe en el archivo binario
		end;
	end;
	close(txt);		
	close(arch);
	writeln('Se creo el archivo');

end;

// Lee una novela de teclado
procedure leerNovela(var n: novela);
begin
	with n do begin
		writeln('Ingrese el codigo de la novela');
		readln(cod);
		writeln('Ingrese el nombre de la novela');
		readln(nombre);
		writeln('Ingrese el precio de la novela');
		readln(precio);
		writeln('Ingrese el genero de la novela');
		readln(genero);
	end;
end;


procedure agregarNovela(var arch:novelas);
var
	existe:boolean;
	nov:novela;
	codABuscar:integer;
begin
	existe:=false;
	leerNovela(nov);
	reset(arch);
	while(not eof(arch) and not existe) do begin
		read(arch,nov);
		if (codABuscar = nov.cod) then
			existe:= true;
	end;
	 if (existe) then
		writeln('No se pudo agregar la novela, ya esta registrada en el archivo')
    else
		write(arch, nov);
		writeln('Se agrego la novela');

	close(arch);
end;

procedure mostrarMenu(var opc:char);
begin
	writeln('-------MENÚ PRINCIPAL------');
	writeln('1) Crear un archivo binario.');
	writeln('2) Actualizar archivo binario.');
	writeln('Presione 0 para salir');
	writeln('Ingrese una opcion:');
	readln(opc);
end;
{-------------programa principal-----------------}
var
	arch:novelas;
	opc:char;
begin
	mostrarMenu(opc);
	while(opc <> '0') do begin
		case opc of
			'1':crearArchivo(arch);
			'2':agregarNovela(arch);
		end;
		mostrarMenu(opc);
	end;
	writeln('- FIN -');
end.
