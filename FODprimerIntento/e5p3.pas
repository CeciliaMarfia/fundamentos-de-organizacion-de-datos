{5. Dada la estructura planteada en el ejercicio anterior, implemente el siguiente módulo:
{Abre el archivo y elimina la flor recibida como parámetro manteniendo la política descripta anteriormente}

const
	valorAlto = 9999;
type
	reg_flor = record
		nombre: String[45];
		codigo:integer;
	end;
	
	tArchFlores = file of reg_flor;
// ------------ FIN DEL TYPE -----------
//LECTURA
procedure leer (var arch: tArchFlores; var dato: reg_flor);
begin
	if (not eof(archivo)) then
		read(archivo,dato)
	else
		dato.nroAsistente := valorAlto;
end;

procedure agregarFlor (var a: tArchFlores ; nombre: string; codigo:integer);
var
	cabecera,flor:reg_flor;
	pos:integer;
begin
	reset(tArch); //abro el archivo ya creado
	leer(tArch, flor); //lo leo
	flor.nombre:= nombre;
	flor.codigo:= codigo;
	//si el código es menor a 0 significa que hubo una baja en el archvo, ntoncs entro al if
	if (cabecera.codigo < 0) then begin
		pos:= cabecera.codigo * (-1); // me guardo la posición donde está el archivo que le voy a dar el alta
		seek(a, pos);// me muevo a la posición donde hubo una baja porque tengo un lugar libre
		leer(tArch, cabecera); //lo leo en esta posicion porque va a ser la nueva cabecera
		seek(a,filepos(a)-1); // vuelvo a la posición anterior por el puntero;
		write(a,flor); //escribo la nueva flor
		seek(a,0); //me muevo a la cabecera del archivo
		write(a,cabecera);
	end
	else
		seek(a,filesize(a)); //me paro al final
		write(a,flor);// guardo la flor nueva;
	close(tArch);
end;

//b. Liste el contenido del archivo omitiendo las flores eliminadas. Modifique lo que considere necesario para obtener el listado.}
procedure imprimir(var a: tArchFlores);
var
	reg:reg_flor;
begin
	reset(tArch); //abro el archivo ya creado
	seek(a,1);// me paro en el 1 porque en el 0 tengo la cabecera
	leer(a,reg);
	while(a.codigo <> valorAlto) do begin
		if(a.codigo > 0) then //si es mayor a 0 no hubo eliminado
			writeln('Flor: ', reg.nombre, 'Codigo: ', reg.codigo)
		else
			write ('-- espacio vacío --'); //verifico que esta eliminado
		leer(a,reg);
	end; 
	close(tArch);
end;


procedure eliminarFlor (var a: tArchFlores; flor:reg_flor); 
var
	reg:reg_flor;
begin
	reset(tArch); //abro el archivo ya creado
	leer(a,cabecera); // me guardo la cabecera
	leer(a,reg); //leo el primer registro válido
	while(a.codigo <> valorAlto) and (a.nombre <> flor.nombre) do //busco la flor con ese nombre
		leer(a,reg);// vuelvo a leer 
	if(a.nombre = flor.nombre) then begin
		seek(a,filepos(a)-1); // retrocedo a la posicion que quiero
		pos:= (filepos(a)*(-1));//me guardo la posicion donde quiero eliminar
		write(a,cabecera);// sobreescribo esa posicion con el registro cabecera
		seek(a,0); //vuelvo al inicio
		reg.codigo:= pos; //en el regisrto a eliminar guardo la pos*(-1) para que sea la cabecera, que sería el último eliminado
		write(a,reg);
	end
	else
		write('No se encontró la flor.');
	close(tArch);
end;
//-- PROGRAMA PRINCIPAL--
begin
end.
