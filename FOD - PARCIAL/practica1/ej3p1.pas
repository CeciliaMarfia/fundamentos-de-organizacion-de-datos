 {3. Realizar un programa que presente un menú con opciones para:
a. Crear un archivo de registros no ordenados de empleados y completarlo con
datos ingresados desde teclado. De cada empleado se registra: número de
empleado, apellido, nombre, edad y DNI. Algunos empleados se ingresan con
DNI 00. La carga finaliza cuando se ingresa el String ‘fin’ como apellido.
b. Abrir el archivo anteriormente generado y
i. Listar en pantalla los datos de empleados que tengan un nombre o apellido
determinado, el cual se proporciona desde el teclado.
ii. Listar en pantalla los empleados de a uno por línea.
iii. Listar en pantalla los empleados mayores de 70 años, próximos a jubilarse.
NOTA: El nombre del archivo a crear o utilizar debe ser proporcionado por el usuario.}
program ej3p1;
const   
    mayores = 70;
    fin = 'fin';
type
    cadena50= string[50];
    empleado = record 
        nroEmp: integer;
        apellido:cadena50;
        nombre:cadena50;
        edad:integer;
        dni:longInt;
    end;
    archivo = file of empleado; //La carga finaliza cuando se ingresa el String ‘fin’ como apellido.
// fin del type
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

procedure crearArchivo(var arch:archivo; var nomArch:cadena50;var existeUnArchivo:boolean);
    procedure cargarDatos(var arch:archivo);
        procedure leerEmpleado(var e: empleado);
	    begin
            with e do begin
                writeln('Ingrese el apellido del empleado o "fin" si quiere terminar');
                readln(apellido);
                if (apellido <> fin) then begin
                    writeln('Ingrese el nombre del empleado');
                    readln(nombre);
                    writeln('Ingrese el numero de empleado');
                    readln(nroEmp);
                    writeln('Ingrese la edad del empleado');
                    readln(edad);
                    writeln('Ingrese el DNI del empleado');
                    readln(dni);
                end;
            end;
        end;
    var
        emp:empleado;
    begin
        leerEmpleado(emp);
        while(emp.apellido <> 'fin') do begin
            write(arch,emp);
            leerEmpleado(emp);
        end;
    end;
begin
    writeln('Usted eligio la opcion "crear un archivo nuevo"');
	existeUnArchivo := true;
	writeln('Ingrese el nombre del archivo'); // Ingreso del nombre fisico del archivo
	readln(nomArch);
	assign(arch, nomArch);//correspondencia archivo lógico - archivo físico:
	rewrite(arch);//Apertura y creación de archivos
	/// como el archivo aun no fue creado lo creo acá y ya puedo escribirle información
	cargarDatos(arch);
	close(arch); //cierre de archivo
end;
procedure mostrarMenuDeListado();
begin
	writeln('-------MENÚ DE LISTADOS------');
	writeln('1. Listar en pantalla los datos de empleados que tengan un nombre o apellido determinado.');
	writeln('2. Listar en pantalla los empleados de a uno por línea.');
	writeln('3. Listar en pantalla empleados mayores de 70 años, próximos a jubilarse.');
end;
procedure listarDatosEmpleado(e: empleado);
begin
	writeln('prueba');
	with e do begin
		write('-> NOMBRE: ', nombre, ' | ');
		write('APELLIDO: ', apellido, ' | ');
		write('NRO DE EMPLEADO: ', nroEmp, ' | ');
		write('EDAD: ', edad, ' | ');
		write('DNI: ', dni, ' | ');
	end;
end;
procedure listarSegunNombreOApellido(var arch:archivo);
var
    emp:empleado;
    apeONom:cadena50;
begin
    writeln('Ingrese nombre y apellido que desea buscar(se buscara por alguno de estos):');
    writeln('nombre:');
    readln(apeONom);
    reset(arch);
        while (not eof(arch)) do begin
            read(arch,emp);
            if(emp.nombre = apeONom) or (emp.apellido = apeONom) then
                listarDatosEmpleado(emp);
//            read(arch,emp);
        end;
    close(arch);
end;
procedure listarEmpleados(var arch:archivo);
var
	emp: empleado;
begin
  writeln('EMPLEADOS ALMACENADOS EN EL ARCHIVO:');
    while (not Eof(arch)) do begin
      read(arch,emp);
      writeln;
      listarDatosEmpleado(emp);
    end;
end;
procedure listarProximosAJubilarse(var arch:archivo);
var
    emp:empleado;
begin
    writeLn('EMPLEADOS PRÓXIMOS A JUBILARSE:');
    while (not eof(arch)) do begin
        read(arch,emp);
        if (emp.edad > mayores) then
            listarDatosEmpleado(emp);
   end;
end;
procedure abrirArchivoCreado(var arch:archivo; var nomArch:cadena50; var existeUnArchivo:boolean);
var
	opcion: char;
begin
    writeln('Usted eligio la opcion "Abrir un archivo"');
    if (existeUnArchivo) then begin //si el archivo existe
		writeln('Ingrese el nombre del archivo que quiere abrir');
		read(nomArch); //leo el nombre del archivo
        reset(arch);
		mostrarMenuDeListado();
        writeln('Ingrese una opcion');
		readln;
		readln(opcion);
		case (opcion) of
			'1': listarSegunNombreOApellido(arch);
			'2': listarEmpleados(arch);
			'3': listarProximosAJubilarse(arch);
		end;
    close(arch); //cierre de archivo
    writeln('* Se acaba de cerrar el archivo: ', nomArch);
    end
	else
			writeln('--El archivo ingresado no es el que acaba de crear--');
end;
// programa principal
var
    arch:archivo;
    nomArch:cadena50;
    opc:char;
    existeUnArchivo:boolean;
begin
    existeUnArchivo:=false;
    mostrarMenuPrincipal(opc);
    while (opc <> 'c') do begin
        case opc of
			'a': crearArchivo(arch, nomArch, existeUnArchivo);//que no sea solo con el archivo que acabo de agregar
			'b': abrirArchivoCreado(arch, nomArch, existeUnArchivo);
		end;
     mostrarMenuPrincipal(opc);
    end;
	writeln('--Ha salido del menú principal--')
end.
