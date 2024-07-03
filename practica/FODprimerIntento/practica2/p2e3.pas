{3. Se cuenta con un archivo de productos de una cadena de venta de alimentos congelados.
De cada producto se almacena: código del producto, nombre, descripción, stock disponible,
stock mínimo y precio del producto.
Se recibe diariamente un archivo detalle de cada una de las 30 sucursales de la cadena. Se
debe realizar el procedimiento que recibe los 30 detalles y actualiza el stock del archivo
maestro. La información que se recibe en los detalles es: código de producto y cantidad
vendida. Además, se deberá informar en un archivo de texto: nombre de producto,
descripción, stock disponible y precio de aquellos productos que tengan stock disponible por
debajo del stock mínimo.
Nota: todos los archivos se encuentran ordenados por código de productos. En cada detalle
puede venir 0 o N registros de un determinado producto.}
program p2e3;

type
	cadena30 = string[30];
	producto = record
		codProd: integer;
		nombreComercial:cadena30;
		precio:real;
		stockActual:integer;
		stockMinimo:integer;
	end;
	
	venta = record
		codProd:integer;
		cantUnidVendidas:integer;
	end;
	
	archivo_producto = file of producto;
	archivo_venta = file of venta;
// ----------- FIN DEL TYPE--------------------
procedure actualizar(var maestro: archivo_producto ;var detalle: archivo_venta);
var
	regm:producto;
	regd:venta;
begin
	assign (maestro, 'maestro');
	assign (detalle, 'detalle');
	
	{proceso principal}
	reset (maestro); 
	reset (detalle);
	while (not eof(detalle)) do begin //mientras no llegue al final del detalle
		read(maestro, regm); //voy leyendo los archivos
		read(detalle,regd);
		while (regm.codProd <> regd.codProd) do
			read (maestro,regm);
		while not eof(detalle) and (regm.codProd = regd.codProd) do begin
			regm.stockActual := regm.stockActual - regd.cantUnidVendidas;
			read (detalle,regd);
		end;
	If not eof(detalle) then
		seek( detalle, filepos(detalle)-1);
	seek (maestro, filepos(maestro)-1);
	write(maestro,regm);
	end;
	close(maestro); 
	close(detalle);
end;

procedure listar (var mae: archivo_producto);
var
	texto : Text;
	prod : producto;
begin
	assign(texto,'stock_minimo.txt');
	rewrite(texto);
	reset(mae);
	while (not eof(mae)) do begin
		read(mae,prod);
		If (prod.stockMinimo < prod.stockActual) then
			writeln(texto, prod.codProd,' ', prod.nombreComercial,' ', prod.precio,' ', prod.stockActual,' ', prod.stockMinimo);
	end;
	close(texto); 
	close(mae);
end;
//------------------PROGRAMA PRINCIPAL-------------------
var
	maestro:archivo_producto;
	detalle: archivo_venta;
	opc:integer;
begin
	repeat
		writeln('-----------------');
		writeln('1: actualizar maestro con un detalle');
		writeln('2: listar en arch texto stock menor al minimo');
		writeln('0: salir');
		readln(opc);
		case opc of
			1: actualizar(maestro,detalle);
			2: listar(maestro);
		end;
	until (opc = 0);
	
end.

