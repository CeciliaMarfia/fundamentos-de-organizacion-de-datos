{2. Se dispone de un archivo con información de los alumnos de la Facultad de Informática. Por
cada alumno se dispone de su código de alumno, apellido, nombre, cantidad de materias
(cursadas) aprobadas sin final y cantidad de materias con final aprobado. Además, se tiene
un archivo detalle con el código de alumno e información correspondiente a una materia
(esta información indica si aprobó la cursada o aprobó el final).
Todos los archivos están ordenados por código de alumno y en el archivo detalle puede
haber 0, 1 ó más registros por cada alumno del archivo maestro. Se pide realizar un
programa con opciones para:

a. Actualizar el archivo maestro de la siguiente manera:
i.Si aprobó el final se incrementa en uno la cantidad de materias con final aprobado.
ii.Si aprobó la cursada se incrementa en uno la cantidad de materias aprobadas sin
final.
b. Listar en un archivo de texto los alumnos que tengan más de cuatro materias
con cursada aprobada pero no aprobaron el final. Deben listarse todos los campos.
NOTA: Para la actualización del inciso a) los archivos deben ser recorridos sólo una vez.}
program p2e2;
type
	cadena30=String[30];
	
	alumno = record
		codAlu: integer;
		apellido:cadena30;
		nombre:cadena30;
		cursada_aprobada:integer;
		final_aprobado:integer;
	end;
	
	materia = record
		codigo: integer;
		cursada_aprobada:boolean;
		final_aprobado:boolean;
	end;
	
	archivo_maestro =  file of alumno;
	archivo_detalle = file of materia;
// ----------- FIN DEL TYPE--------------------
procedure actualizar(var maestro:archivo_maestro;var detalle:archivo_detalle );
var
	alu:alumno; //registro maestro
	mat:materia; //registro detalle
begin
	reset (maestro);
	reset (detalle);
	while (not eof(detalle)) do begin
		read(maestro, alu);
		read(detalle,mat);
		while (mat.codigo<> alu.codAlu) do //voy recorriendo el detalle y quiero que el codigo me coincida con el de el maestro para tener el mismo
		read (maestro,alu);
		if (mat.cursada_aprobada = true) then
			alu.cursada_aprobada:= alu.cursada_aprobada+1;
		if (mat.final_aprobado = true) then
			alu.final_aprobado:= alu.final_aprobado+1;
		seek (maestro, filepos(maestro)-1);
		write(maestro,alu);
	end;
	close(maestro);
	close(detalle);
end;
{procedure listar(var maestro:archivo_maestro;var detalle:archivo_detalle );
var
	//alu:alumno;
begin

end;}
// ----------- PROGRAMA PRINCIPAL--------------------
var
	mae : archivo_maestro;
	det: archivo_detalle;
	//archivo: text; 
begin
	assign(mae,'archivo_maestro');
	assign(det,'archivo_detalle');
	actualizar(mae,det);
	//listar(mae,det);
end.
