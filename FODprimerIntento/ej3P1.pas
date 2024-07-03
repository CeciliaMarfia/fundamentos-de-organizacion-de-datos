{Realizar un programa que presente un menú con opciones para:
a. Crear un archivo de registros no ordenados de empleados y completarlo con
datos ingresados desde teclado. De cada empleado se registra: número de
empleado, apellido, nombre, edad y DNI. Algunos empleados se ingresan con
DNI 00. La carga finaliza cuando se ingresa el String ‘fin’ como apellido.

b. Abrir el archivo anteriormente generado y:
i. Listar en pantalla los datos de empleados que tengan un nombre o apellido determinado.
ii. Listar en pantalla los empleados de a uno por línea.
iii. Listar en pantalla empleados mayores de 70 años, próximos a jubilarse.

NOTA: El nombre del archivo a crear o utilizar debe ser proporcionado por el usuario.
}
program ej3P1;
const
	fin = 'fin';
    mayores = 70;
type
    cadena30 = string[30];
	empleado = record
		nroEmpleado:integer;
		apellido: cadena30;
        nombre:cadena30;
        edad: integer;
        dni:integer;
    end;

    archivo_empleados = file of empleado; // defino un tipo de archivo de empleado que reside en la mem secundaria y es administ por el SO
{--FIN DEL TYPE--}
// Muestra el menu principal con opciones para el usuario y le solicita el ingreso de la eleccion
procedure mostrarMenuPrincipal(var opcion: char);
begin
	writeln;
	writeln('---------- MENU PRINCIPAL ----------');
	writeln('a: Crear un archivo de empleados');
	writeln('b: Abrir el archivo creado anteriormente');
	writeln('c: Salir del menu');
	writeln('Ingrese una opcion');
	readln(opcion);
end;
// Crea un archivo de empleados, le asigna un nombre fisico ingresado por el usuario y lo carga con datos ingresados por teclado
procedure crearArchivo(var arch: archivo_empleados; var nombre_fisico: cadena30; var existe: boolean);
    procedure cargarDatos(var arch:archivo_empleados);
        procedure leerEmpleado(var e: empleado);
	    begin
		with e do begin
			writeln('Ingrese el apellido del empleado o "fin" si quiere terminar');
			readln(apellido);
			if (apellido <> fin) then begin
				writeln('Ingrese el nombre del empleado');
				readln(nombre);
				writeln('Ingrese el numero de empleado');
				readln(nroEmpleado);
				writeln('Ingrese la edad del empleado');
				readln(edad);
				writeln('Ingrese el DNI del empleado');
				readln(dni);
			end;
		end;
	end;
    var
        e:empleado;
    begin
        leerEmpleado(e);
        while(e.apellido <> fin) do begin
          write(arch,e);
          leerEmpleado(e);
        end;
    end;
begin
	writeln('Usted eligio la opcion "crear un archivo creado"');
	existe := true;
	writeln('Ingrese el nombre del archivo'); // Ingreso del nombre fisico del archivo
	readln(nombre_fisico);
	assign(arch, nombre_fisico);//correspondencia archivo lógico - archivo físico:
	rewrite(arch);//Apertura y creación de archivos
	/// como el archivo aun no fue creado lo creo acá y ya puedo escribirle información
	cargarDatos(arch);
	close(arch); //cierre de archivo
end;
// Lista los datos de los empleados
procedure listarDatosEmpleado(e: empleado);
begin
	writeln('prueba');
	with e do begin
		write('-> NOMBRE: ', nombre, ' | ');
		write('APELLIDO: ', apellido, ' | ');
		write('NRO DE EMPLEADO: ', nroEmpleado, ' | ');
		write('EDAD: ', edad, ' | ');
		write('DNI: ', dni, ' | ');
	end;
end;


//i. Listar en pantalla los datos de empleados que tengan un nombre o apellido determinado.
procedure listarSegunNombreOApellido(var arch: archivo_empleados);
var
	e: empleado;
	nombreABuscar,apellidoABuscar: cadena30;
begin
    writeln('Ingrese el nombre a buscar');
	readln(nombreABuscar);
	writeln('Ingrese el apellido a buscar:');
    readln(apellidoABuscar);
    while (not eof (arch)) do begin //mientras no llegue al final del archivo
		read(arch,e);// leo del archivo el registro empleado
        if((nombreABuscar = e.nombre) or (apellidoABuscar = e.apellido)) then
          listarDatosEmpleado(e);
    end;
end;
procedure listarEmpleados(var arch:archivo_empleados);
var
	e: empleado;
begin
  writeln('EMPLEADOS ALMACENADOS EN EL ARCHIVO:');
    while (not Eof(arch)) do begin
      read(arch,e);
      writeln;
      listarDatosEmpleado(e);
    end;
end;
//Listar en pantalla empleados mayores de 70 años, próximos a jubilarse.
procedure listarProximosAJubilarse(var arch:archivo_empleados);
var
    e:empleado;
begin
    writeLn('EMPLEADOS PRÓXIMOS A JUBILARSE:');
    while (not Eof(arch)) do begin
        Read(arch,e);
        if (e.edad > mayores) then
            listarDatosEmpleado(e);

   end;
end;
procedure mostrarMenuDeListado();
begin
	writeln('-------MENÚ DE LISTADOS------');
	writeln('1. Listar en pantalla los datos de empleados que tengan un nombre o apellido determinado.');
	writeln('2. Listar en pantalla los empleados de a uno por línea.');
	writeln('3. Listar en pantalla empleados mayores de 70 años, próximos a jubilarse.');
end;
// Abre el archivo creado anteriormente (si lo hay), muestra un menu con las operaciones disponibles y ejecuta las instrucciones correspondientes
procedure abrirArchivoCreado(var archivo: archivo_empleados; nombre_fisico: cadena30; existeArchivo: boolean);
var
	opcion: char;
begin
    writeln('Usted eligio la opcion "Abrir un archivo"');
    if (existeArchivo) then begin //si el archivo existe
		writeln('Ingrese el nombre del archivo que quiere abrir');
		read(nombre_fisico); //leo el nombre del archivo
        reset(archivo);
		mostrarMenuDeListado();
		writeln('Ingrese una opcion');
		readln;
		readln(opcion);
		case (opcion) of
			'1': listarSegunNombreOApellido(archivo);
			'2': listarEmpleados(archivo);
			'3': listarProximosAJubilarse(archivo);
		end;
		close(archivo);
		writeln('* Se acaba de cerrar el archivo: ', nombre_fisico);
        end
		else
			writeln('--El archivo ingresado no es el que acaba de crear--');
	end;


{--- PROGRAMA PRINCIPAL----}
var
    archivo_logico: archivo_empleados; // el archivo lógico que es utilizado desde el algoritmo cuando este necesita operar con un archivo genera conexion con el SO
	opcion: char; //para manipular el menú
	nombre_fisico: cadena30; // para asignar el archivo
	existeUnArchivo: boolean; //para ver si podemos abrir el archivo
begin
    existeUnArchivo:= false;
    mostrarMenuPrincipal(opcion);
    while (opcion <> 's') do begin// pedir el nombredel archivo
        case (opcion) of
			'a': crearArchivo(archivo_logico, nombre_fisico, existeUnArchivo);//que no sea solo con el archivo que acabo de agregar
			'b': abrirArchivoCreado(archivo_logico, nombre_fisico, existeUnArchivo);
		end;
      mostrarMenuPrincipal(opcion);
    end;
	writeln('--Ha salido del menú principal--')
end.
