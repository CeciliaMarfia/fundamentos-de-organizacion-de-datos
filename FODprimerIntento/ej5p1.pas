{5. Realizar un programa para una tienda de celulares, que presente un menú con
opciones para:
a. Crear un archivo de registros no ordenados de celulares y cargarlo con datos
ingresados desde un archivo de texto denominado “celulares.txt”. Los registros
correspondientes a los celulares, deben contener: código de celular, el nombre,
descripción, marca, precio, stock mínimo y el stock disponible.
b. Listar en pantalla los datos de aquellos celulares que tengan un stock menor al
stock mínimo.
c. Listar en pantalla los celulares del archivo cuya descripción contenga una
cadena de caracteres proporcionada por el usuario.
d. Exportar el archivo creado en el inciso a) a un archivo de texto denominado
“celulares.txt” con todos los celulares del mismo. El archivo de texto generado
podría ser utilizado en un futuro como archivo de carga (ver inciso a), por lo que
debería respetar el formato dado para este tipo de archivos en la NOTA 2.
NOTA 1: El nombre del archivo binario de celulares debe ser proporcionado por el usuario.
NOTA 2: El archivo de carga debe editarse de manera que cada celular se especifique en
tres líneas consecutivas: en la primera se especifica: código de celular, el precio y
marca, en la segunda el stock disponible, stock mínimo y la descripción y en la tercera
nombre en ese orden. Cada celular se carga leyendo tres líneas del archivo
“celulares.txt”.}
program ej5p1;
type
	cadena30 = string[30];
	cadena100 = string[100];
	
	celular = record
		codCelular: integer;
		nombre:cadena30;
		descripcion: cadena100;
		marca:cadena30;
		precio:real;
		stockMin:integer;
		stockDisp:integer;
	end;
	
	celulares = file of celular;
{----------FIN DEL TYPE------------}

// Crea un archivo binario y lo carga a partir de un archivo de texto
procedure crearArchivo(var arch:celulares);
var
	cel: celular;
	txt: text;
	nombre_fisico: cadena30;
begin
	writeln('Ud. eligió la opción 1: "Crear archivo", por favor ingrese el nombre del archivo a crear:');
	readln(nombre_fisico);
	assign(arch,nombre_fisico); // Asigna el nombre logico y el fisico
	assign(txt, 'celulares.txt'); // Le asigno al archivo logico el nombre del archivo fisico que ya cree (y cargue) en mi carpeta de FOD
	reset(txt); // Abre el archivo de texto
	rewrite(arch);
	while (not eof(txt)) do begin //mientras no llegue al final de larchivo voy leyendo los campos del registro y los escribo en el archivo binario
		with cel do begin
			readln(txt, codCelular, precio, marca); 
			readln(txt, stockMin, stockDisp, descripcion);
			readln(txt, nombre);
			write(arch, cel); // Escribe en el archivo binario
		end;
	end;

	close(txt);		
	close(arch);
	
	writeln('Se creo el archivo');
end;

procedure listarDatosCelular(cel:celular);
begin
	with cel do begin
		writeln('-> Codigo: ', codCelular ,
				' | Nombre: ' , nombre ,
				' | Descripcion:' + descripcion ,
				' | Marca: ' , marca ,
				' | Precio: ' , precio:0:0 ,
				' | Stock minimo: ' , stockMin ,
				' | Stock disponible: ' , stockDisp);
	end;

end;
// Lista los datos de aquellos celulares que tengan un stock menor al stock mínimo
procedure listarCelularesMenorStock(var arch: celulares);
var
	cel: celular;
begin
	writeln('Ud. eligió la opción 2: "Listar los datos de aquellos celulares que tengan un stock menor al stock minimo." ');
	reset(arch); //abre el archivo de celulares
	while(not eof(arch)) do begin //mientras no llegue al final de larchivo voy leyendo cada registro, comparo si el stock disp es menor al minimo, en ese caso listo luego cierro 
		read(arch,cel);
		if(cel.stockDisp < cel.stockMin) then
			listarDatosCelular(cel);
	end;
	close(arch);
end;
// Lista los celulares del archivo cuya descripción contenga una cadena de caracteres proporcionada por el usuario.
procedure listarCelularesSegunDescripcion(var arch: celulares);
var
	descrip:cadena100;
	cel:celular;
begin
	writeln('Ud. eligió la opción 3: "Listar los celulares del archivo cuya descripcion contenga una cadena de caracteres proporcionada por el usuario." ');
	writeln('Ingrese la cadena de caracteres');
	readln(descrip);
	reset(arch); //abre el archivo de celulares
	writeln(' --- Celulares que tienen la descripcion ingresada --- ');
	while(not eof(arch)) do begin //mientras no llegue al final de larchivo voy leyendo cada registro, comparo si coinciden las descripciones en ese caso listo luego cierro 
		read(arch,cel);
		if(descrip = cel.descripcion) then
			listarDatosCelular(cel);
	end;
	close(arch);
end;
// Exporta un archivo binario a un archivo de texto
procedure exportarArchivo(var arch: celulares);
var
	txt: text;
	c: celular;
begin
	reset(arch); // Abre el archivo binario

	assign(txt, 'celulares.txt'); // Asigna el nombre fisico con el logico
	rewrite(txt); // Crea el archivo de texto

	while (not eof(arch)) do begin
		read(arch, c);
		with c do begin // Escribe en el archivo de texto
			writeln(txt, codCelular, ' ', precio:0:0, marca);
			writeln(txt, stockDisp, ' ', stockMin, descripcion);
			writeln(txt, nombre);
		end;
	end;

	close(arch);	close(txt);
end;

procedure mostrarMenu(var opc:char);
begin
	writeln('        ** MENÚ PRINCIPAL **           ');
	writeln('1. Crear archivo.');
	writeln('2. Listar los datos de aquellos celulares que tengan un stock menor al stock minimo.');
	writeln('3: Listar los celulares del archivo cuya descripcion contenga una cadena de caracteres proporcionada por el usuario.');
	writeln('4: Exportar archivo creado a un archivo de texto con todos los celulares.');
	writeln('5. Salir.');
	writeln('Ingrese una opcion:');
	readln(opc);
end;
{-----------PROGRAMA PRINCIPAL ------------}
var
	opcion: char;
	arch: celulares;

begin
		mostrarMenu(opcion);
		while(opcion <> '5') do begin
			case (opcion) of
				'1': crearArchivo(arch);
				'2':listarCelularesMenorStock(arch);
				'3':listarCelularesSegunDescripcion(arch);
				'4':exportarArchivo(arch);
			end;
		mostrarMenu(opcion);
		end;
		writeln('- FIN.');
end.
