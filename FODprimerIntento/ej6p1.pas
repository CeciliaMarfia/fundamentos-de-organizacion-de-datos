{6)Agregar al menú del programa del ejercicio 5, opciones para:
a. Añadir uno o más celulares al final del archivo con sus datos ingresados por teclado.
b. Modificar el stock de un celular dado.
c. Exportar el contenido del archivo binario a un archivo de texto denominado: ”SinStock.txt”, con aquellos celulares que tengan stock 0.
NOTA: Las búsquedas deben realizarse por nombre de celular.
}

program ej6p1;
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

procedure leerCelular (var cel:celular);
begin
	with cel do begin
		writeln('*Codigo del celular: ');
		readln(codCelular);
		writeln('*Nombre: ');
		readln(nombre);
		writeln('*Descripción: ');
		readln(descripcion);
		writeln('*Precio: ');
		readln(precio);
		writeln('*Marca: ');
		readln(marca); 
		writeln('*Stock mínimo: ');
		readln(stockMin);
		writeln('*Stock disponible: ');
		readln(stockDisp);
	end;
end;

// Recibe un archivo y un nombre de celular y devuelve si ese celular existe en el archivo
procedure existeCelular(var arch: celulares; var existe: boolean; var stock: integer; nombre: cadena30);
var
	celu: celular;
begin
	while ( (not existe) AND (not eof(arch)) ) do begin
		read(arch, celu); // Lee un celular del archivo
		if (celu.nombre = nombre) then begin // Si el nombre del celular leido coincide con el leido por teclado (traido por parametro)
			existe := true;
			stock := celu.stockDisp;
		end;
	end;
end;


procedure agregarCelular(var arch: celulares);
var
	cel:celular;
	existe: boolean;
	stock:integer;
begin
		//si el nombre de celular existe, agrego los datos al celular correspondiente, sino agrego uno nuevo.
		writeln(' Usted eligió la opción 5: "Agregar un celular"');
		existe := false;
		leerCelular(cel);
		reset(arch);
		existeCelular(arch, existe, stock, cel.nombre);
		if (existe) then begin
			cel.stockDisp := cel.stockDisp + stock;
		writeln('se actualizo el stock del celular ingresado');
		end
    else
		writeln('Se agrego el celular');
	seek(arch, filePos(arch)-1);
	write(arch, cel);
	close(arch);	
end;

// Modifica el stock (elegido por el usuario) de un celular dado (elegido por el usuario)
procedure modificarStock(var arch: celulares);
var
	cel: celular;
	found: boolean;
	nomABuscar: cadena30;
	nuevoStock: integer;
begin
	writeln('Ingrese un nombre de celular para actualizar su stock');
	readln(nomABuscar);
	found := false;
	reset(arch); // Abre el archivo
	while(not eof(arch) and (not found)) do begin
		read(arch,cel);
		if (cel.nombre = nomABuscar) then begin
			writeln('Ingrese el nuevo stock disponible');
			readln(nuevoStock);
			cel.stockDisp:= cel.StockDisp + nuevoStock;
			found:=true; //encontré el celular
		end;
	end;
	seek(arch, filePos(arch)-1);
	write(arch, cel);
	close(arch);
end;
// Escribe en el archivo de texto el celular recibido por parametro
procedure cargarDatosTxt(var txt: text; c: celular);
begin
	with c do begin
			writeln(txt, codCelular, ' ', precio:0:0,' ', marca);
			writeln(txt, stockDisp, ' ', stockMin,' ', descripcion);
			writeln(txt, nombre);
	end;
end;

// Exporta un archivo binario a un archivo de texto con los celulares que tengan stock 0
procedure exportarArchivoATxtSinStock(var arch: celulares);
var
	txt: text;
	cel: celular;
begin
	assign(txt, 'SinStock.txt'); // Asigna el nombre fisico con el logico
	rewrite(txt); // Crea el archivo de texto
	reset(arch); // Abre el archivo binario

	while (not eof(arch)) do begin
		read(arch, cel);
		if (cel.stockDisp = 0) then
			cargarDatosTxt(txt, cel);
	end;

	close(arch);	
	close(txt);
end;

procedure mostrarMenu(var opc:char);
begin
	writeln('        ** MENÚ PRINCIPAL **           ');
	writeln('1. Crear archivo.');
	writeln('2. Listar los datos de aquellos celulares que tengan un stock menor al stock minimo.');
	writeln('3: Listar los celulares del archivo cuya descripcion contenga una cadena de caracteres proporcionada por el usuario.');
	writeln('4: Exportar archivo creado a un archivo de texto con todos los celulares.');
	writeln('5: Agregar un celular');
	writeln('6: Modificar stock de un celular');
	writeln('7: Exportar archivo creado a un archivo de texto con celulares sin stock');
	writeln('0. Salir.');
	writeln('Ingrese una opcion:');
	readln(opc);
end;
{-----------PROGRAMA PRINCIPAL ------------}
var
	opcion: char;
	arch: celulares;

begin
		mostrarMenu(opcion);
		while(opcion <> '0') do begin
			case (opcion) of
				'1': crearArchivo(arch);
				'2':listarCelularesMenorStock(arch);
				'3':listarCelularesSegunDescripcion(arch);
				'4':exportarArchivo(arch);
				'5': agregarCelular(arch);
				'6':modificarStock(arch);
				'7':exportarArchivoATxtSinStock(arch);
			end;
		mostrarMenu(opcion);
		end;
		writeln('- FIN.');
end.
