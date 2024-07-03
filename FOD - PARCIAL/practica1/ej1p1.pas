{1. Realizar un algoritmo que cree un archivo de números enteros no ordenados y permita
incorporar datos al archivo. Los números son ingresados desde teclado. La carga finaliza
cuando se ingresa el número 30000, que no debe incorporarse al archivo. El nombre del
archivo debe ser proporcionado por el usuario desde teclado}

program ej1p1;
const
    fin = 30000;
type
    archivo = file of integer; 
// programa principal
var
    arch:archivo;
    nombre_fisico: String;
    num: integer;
begin
    writeln('Ingrese el nombre del archivo:');
    readln(nombre_fisico);
    assign(arch,nombre_fisico);
    rewrite(arch); //creo el archivo
    writeln('Ingrese un número:');
    readln(num);
    while(num <> fin) do begin
        write(arch,num);
        writeln('Ingrese un número:');
        readln(num);
    end;
    close(arch);//cierro el archivo
end.
