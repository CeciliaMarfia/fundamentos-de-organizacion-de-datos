{1. Una empresa posee un archivo con información de los ingresos percibidos por diferentes
empleados en concepto de comisión, de cada uno de ellos se conoce: código de empleado,
nombre y monto de la comisión. La información del archivo se encuentra ordenada por
código de empleado y cada empleado puede aparecer más de una vez en el archivo de
comisiones.
Realice un procedimiento que reciba el archivo anteriormente descrito y lo compacte. En
consecuencia, deberá generar un nuevo archivo en el cual, cada empleado aparezca una
única vez con el valor total de sus comisiones.
NOTA: No se conoce a priori la cantidad de empleados. Además, el archivo debe ser
recorrido una única vez.}
program ej1p2;
const 
    valorAlto = 9999;
type
    cadena50 = string[50];
    empleado = record
        codEmp: integer; //ordenado por cod
        nombre: cadena50;
        monto: real;
    end;

    comision = record
        montoTotal: real;
    end;

    archivo = file of empleado;

{-----FIN DEL TYPE------}
//Compactar Archivo
procedure leerArchivo (var det: archivo; var dato: empleado);
begin
	if(not eof(det))then
		read(det, dato)
	else
		dato.codEmp:= valorAlto;
end;

procedure compactar(var mae:archivo; var det:archivo);
var 
    emp,act:empleado;
    total:real;
begin
    reset(det);
    rewrite(mae);
    leerArchivo(det,emp);
    while(emp.codEmp <> valorAlto)do begin{ verifica que no se termine detalle (while (not eof(d))do)}
		act:= emp;
		total:= 0;
		while(emp.codEmp = act.codEmp)do begin{mientras que sea igual a mi codigo itera sumando la comision}
			total:= total + emp.monto;{no pregunta si se termino el archivo porq con el proc leer si es eof no lo lee y tira valorAlto}
			leerArchivo(det, emp);
		end;
        {una vez que tengo el total de comisiones de un empleado agrego al maestro}
		act.monto:= total;
		write(mae, act);
	end;
	close(mae);
	close(det);
end;

{-----PROGRAMA PRINCIPAL-------}
var
    mae:archivo;
    det:archivo;

begin
    assign(mae,'maestro');
    assign(det,'detalle');
    compactar(mae,det);
end.
