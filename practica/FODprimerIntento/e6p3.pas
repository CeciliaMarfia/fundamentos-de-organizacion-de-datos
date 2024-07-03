{6. Una cadena de tiendas de indumentaria posee un archivo maestro no ordenado con la información correspondiente a las prendas que se encuentran a la venta. 
De cada prenda se registra: cod_prenda, descripción, colores, tipo_prenda, stock y precio_unitario. Ante un eventual cambio de temporada, se deben actualizar las prendas a la venta. 
Para ello reciben un archivo conteniendo: cod_prenda de las prendas que quedarán obsoletas. Deberá implementar un procedimiento que reciba

ambos archivos y realice la baja lógica de las prendas, para ello deberá modificar el stock de la prenda correspondiente a valor negativo.
Adicionalmente, deberá implementar otro procedimiento que se encargue de efectivizar las bajas lógicas que se realizaron sobre el archivo maestro con la información de las prendas a la venta. Para ello se deberá utilizar una estructura auxiliar (esto es, un archivo nuevo), en el cual se copien únicamente aquellas prendas que no están marcadas como borradas. Al finalizar este proceso de compactación del archivo, se deberá renombrar el archivo nuevo con el nombre del archivo maestro original.}
const
	valorAlto = 9999;
type
	cadena30 = string[30];
	prenda = record
		cod_prenda: integer;
		 descripcion: cadena30;
		 colores,:cadena30; 
		 tipo_prenda:cadena30;
		 stock:integer;
		 precio_unitario: integer;
	end;
	
	maestro = file of prenda;
	detalle = file of integer;
	
// --- FIN DEL TYPE --
//LECTURA
procedure leerReg(var reg: prenda); 
begin
	writeln('ingrese el codigo de la prenda : ');
	readln(reg.codigo);
	if (reg.codigo <> valorAlto) then begin
		writeln('ingrese la descripcion de la prenda : ');
		readln(reg.descripcion);
		writeln('ingrese los colores de la prenda : ');
		readln(reg.colores);
		writeln('ingrese el tipo de prenda : ');
		readln(reg.tipo);
		writeln('ingrese el stock de la prenda : ');
		readln(reg.stock);
		writeln('ingrese el precio de la prenda : ');
		readln(reg.precio);
	end; 
end; 

procedure crearMaestro(var m: maestro);
var
	reg: prenda; 
begin
	assign(m,'maestro');
	writeln(' - creacion del archivo maestro -');
	rewrite(m);
	leerReg(reg);
	while (reg.codigo <> valorAlto) do begin
		write(m,reg);
		leerReg(reg);
	end; 
	close(m);
end; 

procedure crearDetalle(var d : detalle);
var
	num: integer; 
begin
	writeln(' - creacion del detalle -');
	assign(d,'detalle');
	rewrite(d);
	writeln('ingrese el codigo de prenda que desea dar de baja: ');
	readln(num);
	while (num <> valorAlto ) do begin
		write(d, num);
		writeln('ingrese el codigo de prenda que desea dar de baja: ');
		readln(num);
    end; 
	close(d);
end;
// leer maestro
procedure leerM (var m: maestro; var p: prenda);
begin
	if (not eof(m)) then
		read(m,p)
	else
		p.codigo := valorAlto;
end;
// leer detalle
procedure leerD (var d: detalle; var i: integer);
begin
	if (not eof(d)) then
		read(d,i)
	else
		i := valorAlto;
end;

procedure bajaLogica(var mae:maestro; var det:detalle);
var
	pre:prenda;
	codigo:integer;
begin
	reset(mae);
	reset(det);
	leerD(det,codigo);
	while( codigo <> valorAlto) do begin 
		seek(mae,0); //me paro al comienzo del maestro
		leerM(mae,pre); // leo el primero
		while((pre.codigo <> valorAlto) and (pre.codigo <> codigo)) do 
			leerM(mae,pre); //una vez que encuentro la prenda
		if (pre.codigo = codigo) then begin //como lo encontre realizo la baja logica
			pre.stock := pre.stock * (-1);
			seek(mae, filepos(mae)-1);
			write(mae,pre);
		end
		else
			writeln('No se encontró el codigo de la prenda');
		leerD(det,codigo);	
	end;
	close(mae);
	close(det);
end;

procedure compactar(var mae:maestro; var nue:maestro);
var
	reg:prenda;
begin
	reset(mae);
	assign(nue, 'nuevo');
	rewrite(nue);
	writeln(' - creacion del nuevo -');
	leerM(mae,reg);
	while(reg.codigo <> valorAlto) do begin
		if(reg.stock > 0) then 
			write(nue,reg);
		leerM(mae,reg);
	end;
	close(mae); close(nue);
	erase(mae); //para borrar el nuevo
	rename(nue, 'maestro');// para renombrar el nuevo archivo maestro
end;
// --- PROGRAMA PRINCIPAL--
var 
  nuevo,maestro: am; 
  detalle : ad; 
BEGIN
  assign(maestro,'maestro');
  assign(detalle,'detalle');
  assign(nuevo, 'nuevo');
  //crearMaestro(maestro);
  //crearDetalle(detalle);
  writeln('---------------------------------');
  writeln('maestro sin modificar : ');
  //imprimir(maestro);
  bajaLogica(maestro,detalle);
  writeln('---------------------------------');
  writeln('maestro con baja logica : ');
  imprimir(maestro);
  nuevoArchivo(nuevo,maestro);
  writeln('---------------------------------');
  writeln('maestro - nuevo archivo - : ');
  imprimir(nuevo);
END.
