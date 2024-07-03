{A partir de información sobre la alfabetización en la Argentina, se necesita actualizar un
archivo que contiene los siguientes datos: nombre de provincia, cantidad de personas
alfabetizadas y total de encuestados. Se reciben dos archivos detalle provenientes de dos
agencias de censo diferentes, dichos archivos contienen: nombre de la provincia, código de
localidad, cantidad de alfabetizados y cantidad de encuestados. Se pide realizar los módulos
necesarios para actualizar el archivo maestro a partir de los dos archivos detalle.
NOTA: Los archivos están ordenados por nombre de provincia y en los archivos detalle
pueden venir 0, 1 ó más registros por cada provincia}
program p2e4;
// un maestro, dos detalles. 
const
	valorAlto = 'ZZZ';
type

	cadena = string[20];
	datoMae = record
		provincia : cadena;
		personasAlf : integer;
		encuestados : integer;
	end;
	datoDet = record     // seran 2
		provincia : cadena;
		localidad : integer;
		personasAlf : integer;
		encuestados : integer;
	end;
	archivo_maestro = file of datoMae;
	archivo_detalle = file of datoDet;
//-------------FIN DEL TYPE--------------

//el procedimiento leer es el responsable de realizar el read correspondiente sobre el archivo, en caso de que este tuviera más datos. 
//En caso de alcanzar el eof se asigna el dato.criteriodeorden. Este valor indicara que el puntero ha llegado al eof
procedure leer (var archivo: archivo_detalle; var dato: datoDet);
begin
	if (not eof(archivo)) then
		read(archivo,dato)
	else
		dato.provincia := valorAlto; //porque estan ordenadas por provincia
end;
//el procedimiento minimo busca determinar el menor de los dos elementos recibidos de cada archivo (para poder retornarlo como el más pequeño) y 
//leer otro registro del archivo desde donde provenía ese elemento
procedure minimo (var d1,d2,min: datoDet);
begin
	if (d1.provincia <= d2.provincia) then begin
		min := d1;
		leer(det1,d1);
	end 
		else begin
			min := d2;
			leer(det2,d2);
		end;
end;

//-------------PROGRAMA PRINCIPAL--------------
var
	mae:archivo_maestro;
	det1:archivo_detalle;
	det2:archivo_detalle; 
	
	regm:datoMae;
	aux,min,regd1,regd2:datoDet;
begin
	assign(mae,'maestro');
	assign(det1,'detalle1');
	assign(det2,'detalle2');
	
	reset(mae);
	reset(det1);
	resetdet2);
	
	read(mae,regm);
	leer(det1,regd1);
	leer(det2,regd2);
	
	minimo(regd1,regd2,min);
	
	{se procesan todos los registros de los archivos detalle}
	while(min.provincia  <> valorAlto) do begin
		{se totaliza}
		aux=min.provincia
		while (aux.provincia = min.provincia) do begin
			aux.personasAlf := aux.personasAlf + min.personasAlf;
			aux.encuestados := aux.encuestados + min.encuestados;
			minimo(regd1,regd2,min);
			
		while (regm.provincia <> min.provincia) do begin
			read(mae,regm);
			aux:=//ayuda
			minimo(d1,d2,min);
		end;
		{se reubica el puntero en el maestro}
		seek(mae, filepos(mae)-1);
		
		{se actualiza el maestro}
		write(mae,m);
	end;
		
		close(mae); 
		close(det1); 
		close(det2);
end;

