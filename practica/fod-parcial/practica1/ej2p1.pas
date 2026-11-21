 {2. Realizar un algoritmo, que utilizando el archivo de números enteros no ordenados
creado en el ejercicio 1, informe por pantalla cantidad de números menores a 1500 y el
promedio de los números ingresados. El nombre del archivo a procesar debe ser
proporcionado por el usuario una única vez. Además, el algoritmo deberá listar el
contenido del archivo en pantalla.}
program ej2p1;
const
    menoresA = 1500;
type
    archivo = file of integer;
// fin del type
    procedure cantMenores(var arch:archivo; var cantNum:integer;var promedio:real);
    var
        num,suma,total:integer;
    begin
        suma:= 0;
        total:=0;
        reset(arch); //abro el archivo
        read(arch,num); //leo y guardo en el registro
            while (not eof(arch)) do begin
                if (num < menoresA) then cantNum:= cantNum + 1;
                suma:= suma + num;
                total:=total+1;
                read(arch,num);
               writeln(num);
            end;
            promedio:= suma / total;
        close(arch);
    end;
// programa principal
var
    arch:archivo;
    nomArch:String;
    cantNum:integer;
	promedio:real;
begin
    cantNum:=0;
    writeln('Ingrese el nombre del archivo que desea abrir:');
    readln(nomArch);
    assign(arch,nomArch);
    cantMenores(arch,cantNum,promedio);
    writeln('Cantidad de números menores a ',menoresA,':',cantNum);
    writeln('Promedio: ',promedio:4:2);
end.
