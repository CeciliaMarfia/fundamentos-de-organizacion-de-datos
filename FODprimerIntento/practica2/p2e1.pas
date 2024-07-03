{Una empresa posee un archivo con información de los ingresos percibidos por diferentes
empleados en concepto de comisión, de cada uno de ellos se conoce: código de empleado,
nombre y monto de la comisión. La información del archivo se encuentra ordenada por
código de empleado y cada empleado puede aparecer más de una vez en el archivo de
comisiones.
Realice un procedimiento que reciba el archivo anteriormente descrito y lo compacte. En
consecuencia, deberá generar un nuevo archivo en el cual, cada empleado aparezca una
única vez con el valor total de sus comisiones.
NOTA: No se conoce a priori la cantidad de empleados. Además, el archivo debe ser
recorrido una única vez.}
program p2e1;
type

	cadena30 = string[30];
	
	empleado = record
		codEmp:integer;
		nombre: cadena30;
		montoComision: real;
		end;
		
		archivo_empleado = file of empleado; // ordenado por codigo de empleado, cada empleado puede aparecer mas de una vez 
		


// ----------- FIN DEL TYPE--------------------
procedure compactar(var maestro:archivo_empleado;var detalle:archivo_empleado);
var
	aux, emp:empleado; //vos tenes un registro del que lees del detalle y necesitas el registro auxiliar para guardarte en el maestro
begin
	assign(maestro,'archivo_maestro');
	rewrite(maestro); //como el maestro no existe lo creo
	reset(detalle);// debería tenerlo creado, por eso no puedo probar la ejecución
	read(detalle,emp); //leo el archivo detalle
	while(not eof(detalle)) do begin
		aux.codEmp:= emp.codEmp; //me guardo el codigo del empleado actual
		aux.nombre:= emp.nombre;//me guardo el nombre del actual
		aux.montoComision:=0;
		while(aux.codEmp = emp.codEmp) do begin
			aux.montoComision:=aux.montoComision + emp.montoComision; //voy sumando los montos de el empleado actual
			read(detalle,emp); //para ver si el código del empleado es el actual o ya cambié
		end;//salgo porque cambió el código del empleado
		write(maestro,aux);
	end;
	close(maestro);
	close(detalle);
end;
// ----------- PROGRAMA PRINCIPAL--------------------
var
	maestro: archivo_empleado;
	detalle: archivo_empleado; //el compacto
begin
	compactar(maestro, detalle);
end.
