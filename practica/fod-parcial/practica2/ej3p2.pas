{3. El encargado de ventas de un negocio de productos de limpieza desea administrar el stock
de los productos que vende. Para ello, genera un archivo maestro donde figuran todos los
productos que comercializa. De cada producto se maneja la siguiente información: código de
producto, nombre comercial, precio de venta, stock actual y stock mínimo. Diariamente se
genera un archivo detalle donde se registran todas las ventas de productos realizadas. De
cada venta se registran: código de producto y cantidad de unidades vendidas. Se pide
realizar un programa con opciones para:
a. Actualizar el archivo maestro con el archivo detalle, sabiendo que:
● Ambos archivos están ordenados por código de producto.
● Cada registro del maestro puede ser actualizado por 0, 1 ó más registros del
archivo detalle.
● El archivo detalle sólo contiene registros que están en el archivo maestro.
b. Listar en un archivo de texto llamado “stock_minimo.txt” aquellos productos cuyo
stock actual esté por debajo del stock mínimo permitido.}
program ej3p2;
const
    valorAlto = 9999;
type
    producto = record 
        codProd: integer; //ordenadas por esto
        nomComercial: string;
        precio:real;
        stockA:integer;
        stockM:integer;
    end;

    venta = record
        codProd: integer;
        cantUVendidas: integer;
    end;
    maestro = file of producto;
    detalle = file of venta;
{---FIN DEL TYPE----}
procedure leerProducto(var p : producto);
begin
  writeln('ingrese el codigo del producto : ');
  readln(p.codProd);
  if (p.codProd <> 0)then begin
      writeln('ingrese el nombre del producto : ');
      readln(p.nomComercial);
      writeln('ingrese el precio del producto : ');
      readln(p.precio);
      writeln('ingrese el stock actual del producto : ');
      readln(p.stockA);
      writeln('ingrese el stock minimo del producto : ');
      readln(p.stockM);
    end; 
end; 
procedure generarMaestro(var mae:maestro);
var 
    prod:producto;
begin
    rewrite(mae);
    leerProducto(prod);
    while(prod.codProd <> 0) do begin
        write(mae,prod);
        leerProducto(prod);
    end;
    close(mae);
end;
procedure leerVenta(var v:venta);
begin
  writeln('ingrese el codigo del producto : ');
  readln(v.codProd);
  if (v.codProd <> 0)then begin
      writeln('ingrese la cantidad de unidades vendidas : ');
      readln(v.cantUVendidas);
    end; 
end; 
procedure generarDetalle(var det:detalle);
var 
    ven:venta;
begin
    rewrite(det);
    leerVenta(ven);
    while(ven.codProd <> 0) do begin
        write(det,ven);
        leerVenta(ven);
    end;
    close(det);
end;
procedure leerVen(var det:detalle; var ven:venta);
begin
    if (not eof(det)) then
        read(det,ven)
    else
        ven.codProd:=valorAlto;
end;
procedure actualizar(var mae:maestro; var det:detalle);
var
    prod:producto;
    ven:venta;
begin
    reset(mae);
    reset(det);
    read(mae,prod);
    leerVen(det,ven);
    while(ven.codProd <> valorAlto) do begin //primero busco en el detalle
        while(ven.codProd <> prod.codProd)do 
			read(mae, prod);//{se busca en el maestro el producto del detalle}
		while(ven.codProd = prod.codProd)do begin
			prod.stockA:= prod.stockA - ven.cantUVendidas;
			leerVen(det,ven);
        end;
            seek(mae, filePos(mae)-1);
            write(mae,prod);
    end;
        close(mae);
        close(det);
end;
procedure exportar(var mae:maestro);
var
    arch:text;
    prod:producto;
begin
    assign(arch,'stock_minimo.txt');
    rewrite(arch);
    reset(mae);
    while(not eof(mae)) do begin
        read(mae,prod);
        if(prod.stockA < prod.stockM) then begin
            writeln(arch, prod.codProd);
            writeln(arch, prod.nomComercial);
            writeln(arch, prod.precio,'',prod.stockA,'',prod.stockM);
        end;
    end;
    close(mae);
    close(arch);
end;

{---PROGRAMA PRINCIPAL----}
var
    mae: maestro;
    det: detalle;
    num: integer;
begin
    assign(mae,'maestro');
    assign(det, 'detalle');
    num:=1;
  while (num <> 0)do begin
      writeln('bienvenido al menu principal, ingrese : ');
      writeln('0- Para finalizar');
      writeln('1- Para generar un archivo maestro donde figuran todos los productos');
      writeln('2- Para generar un archivo detalle nuevo con todas las ventas');
      writeln('3- Para actualizar el archivo maestro con el detalle');
      writeln('4- Para exportar los nombres de los productos donde su stock actual sea menor que el minimo');
      writeln('Ingrese una opción:');
      readln(num);
      case num of
        0: writeln('menu finalizado');
        1: generarMaestro(mae);
        2: generarDetalle(det);
        3: actualizar(mae,det);
        4: exportar(mae);
      else
        writeln('numero no valido');
      end;
    end; 
end.
