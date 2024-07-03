{5. Realizar un programa para una tienda de celulares, que presente un menú con
opciones para:
a. Crear un archivo de registros no ordenados de celulares y cargarlo con datos
ingresados desde un archivo de texto denominado “celulares.txt”. Los registros
correspondientes a los celulares deben contener: código de celular, nombre,
descripción, marca, precio, stock mínimo y stock disponible.
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
tres líneas consecutivas. En la primera se especifica: código de celular, el precio y
marca, en la segunda el stock disponible, stock mínimo y la descripción y en la tercera
nombre en ese orden. Cada celular se carga leyendo tres líneas del archivo
“celulares.txt”.}
program ej5p1;
type
    cadena50=string[50];
    celular = record
        cod: integer;
        nombre: cadena50;
        descrip: cadena50;
        marca: cadena50;
        precio: real;
        sMinimo: integer;
        sDisponible: integer;
    end;
    
    archivo = file of celular;
{------FIN DEL TYPE-----}

{crea un archivo a partir del txt. Inciso a }
procedure crearArchivo(var arch:archivo;var atxt: text);
var
    cel:celular;
    nomArch:cadena50;
begin
    writeln('Ingrese el nombre del archivo a crear : ');
    readln(nomArch);
    assign(arch,nomArch);
    assign(atxt,'celulares.txt');
    rewrite(arch); //creo el binario
    reset(atxt); //a partir del txt
    while(not eof(atxt)) do begin
        readln(atxt,cel.cod, cel.precio,cel.marca);
        readln(atxt,cel.sDisponible,cel.sMinimo,cel.descrip);{lectura de archivo de texto}
        readln(atxt,cel.nombre);
        write(arch,cel);
    end;
    close(arch);
    close(atxt);
end;

procedure imprimirDatos(cel:celular);
begin
    with cel do begin
        writeln('codigo del celular: ',cod );
        writeln('nombre del celular: ',nombre );
        writeln('descripcion del celular: ',descrip );
        writeln('marca del celular: ',marca );
        writeln('precio del celular: ',precio );
        writeln('stock minimo del celular: ',sMinimo );
        writeln('stock disponible del celular: ',sDisponible );  
    end;
end;
{inciso b: Listar en pantalla los datos de aquellos celulares que tengan un stock menor al
stock mínimo.}
procedure listadoStockMM(var arch:archivo);
var
    cel:celular;
begin
    reset(arch);
    while(not eof(arch)) do begin
        read(arch,cel);
        if(cel.sDisponible< cel.sMinimo) then
            imprimirDatos(cel);
    end;
    close(arch);
end;
{Inciso c:  Listar en pantalla los celulares del archivo cuya descripción contenga una cadena de caracteres proporcionada por el usuario.}
procedure listadoDeCoincidencia(var arch: archivo);
var
  cel: celular;
  des: cadena50;
begin
    writeln('Ingrese una descripción: ');
    readln(des);
    des:= ' '+ des; {por como esta escrito delante del string debe haber un espacio}
    reset(arch);
    while (not eof(arch))do begin
      read(arch,cel);
      if (cel.descrip = des)then imprimirDatos(cel);
    end; 
  close(arch);
end; 
{Inciso d: Exportar el archivo creado en el inciso a) a un archivo de texto denominado
“celulares.txt” con todos los celulares del mismo. El archivo de texto generado
podría ser utilizado en un futuro como archivo de carga (ver inciso a), por lo que
debería respetar el formato dado para este tipo de archivos en la NOTA 2.}
procedure exportar(var arch:archivo);
var
	atxt: text;
	cel:celular;
begin
    reset(arch); //a partir del binario
    assign(atxt,'celulares.txt');
    rewrite(atxt); //creo el txt
    while(not eof(arch)) do begin
        read(arch,cel);
        writeln(atxt,cel.cod,'', cel.precio,'',cel.marca);
        writeln(atxt,cel.sDisponible,'',cel.sMinimo,'',cel.descrip);
        writeln(atxt,cel.nombre);
    end;
    close(arch);
    close(atxt);
end;
procedure menuPrincipal();
begin
    writeln('------MENÚ PRINCIPAL-----');
    writeln('Opción 1: si desea cargar en un archivo todos los datos de los celulares a partir de un archivo de texto');
    writeln('Opción 2: si desea que se muetre en pantalla los celulares (datos) que tienen stock menor al minimo');
    writeln('Opción 3:si desea que se muestre en pantalla los celulares (datos) que tengan una descripcion como una ingresada por usted');
    writeln('Opción 4: si desea exportar el archivo generado a otro archivo de texto');
    writeln('Opción 0: si desea finalizar con el menú.');
end;
procedure menu(var arch:archivo;var atxt:text);
var
    opc:integer;
begin
    menuPrincipal;
    write('Ingrese una opción:');
    readln(opc);
    while (opc <> 0) do begin
        case opc of
            0:writeln('** Fin ** ');
            1: crearArchivo(arch,atxt);
            2: listadoStockMM(arch);
            3: listadoDeCoincidencia(arch);
            4: exportar(arch);
        else
      writeln('numero no valido');
        end;
    end;
end;
{---PROGRAMA PRINCIPAL----}
var 
  arch : archivo;
  atxt : text;
BEGIN
  menu(arch,atxt);
END.
