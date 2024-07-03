{5. Se cuenta con un archivo de productos de una cadena de venta de alimentos congelados.
De cada producto se almacena: código del producto, nombre, descripción, stock disponible,
stock mínimo y precio del producto.
Se recibe diariamente un archivo detalle de cada una de las 30 sucursales de la cadena. Se
debe realizar el procedimiento que recibe los 30 detalles y actualiza el stock del archivo
maestro. La información que se recibe en los detalles es: código de producto y cantidad
vendida. Además, se deberá informar en un archivo de texto: nombre de producto,
descripción, stock disponible y precio de aquellos productos que tengan stock disponible por
debajo del stock mínimo. Pensar alternativas sobre realizar el informe en el mismo
procedimiento de actualización, o realizarlo en un procedimiento separado (analizar
ventajas/desventajas en cada caso).
Nota: todos los archivos se encuentran ordenados por código de productos. En cada detalle
puede venir 0 o N registros de un determinado producto.}
program ej5p2;
const
  valorAlto = 9999; 
type
    producto = record
        codProd: integer; 
        nomProd: String; 
        descripcion : String; 
        stockD: integer; 
        stockM: integer; 
        precio : real; 
    end; 
  
    venta = record
        codProd: integer; 
        cantVen: integer; 
    end; 

    maestro = file of producto; 
    detalle = file of venta; 


    //uso vectores para poder guardar los 30 detalles y el primer reg de cada uno
    vec_detalle = array [1..30] of detalle; 
    vec_registro = array [1..30] of venta; 
{---FIN DEL TYPE----}
procedure leer(var det: detalle ; var ven : venta);
begin
  if (not eof(det))then
    read(det,ven)
  else
    ven.codProd := valorAlto;
end; 

procedure minimo(var vec_det: vec_detalle; var vec_reg : vec_registro;  var min : venta);
var
  i: integer; 
  pos: integer; 
begin
  //arranca en valor alto ya que quiero sacar el minimo
  min.codProd :=valorAlto;
  pos:=0;
  //saco el minimo del vec de registros de los n detalles
  for i:= 1 to 30 do
    begin
      if (vec_reg[i].codProd<min.codProd)then
        min:= vec_reg[i];
        pos:= i;
    end;
  //ya tengo la pos y el valor minimo
  //si no es valorAlto es xq todavia no se terminaron los 30 archivos
  if (min.codProd <> valorAlto) then  
    //leo el sig reg para ponerlo en el vector 
    leer(vec_det[pos],vec_reg[pos]); 
end; 
//procedimientos para actualizar al maestro

procedure actualizar (var mae : maestro; var vec_det: vec_detalle; var vec_reg : vec_registro );
var
  produc: producto;
  i : integer; 
  min: venta; 
begin
  reset(mae);
  //abro los 30 detalles y leo el primer reg de cada uno 
  for i:= 1 to 30 do begin
      reset(vec_det[i]);
      leer(vec_det[i],vec_reg[i]); 
    end; 
  minimo(vec_det,vec_reg,min);
  while (min.codProd <> valorAlto)do
    begin
      //leo uno del  maestro
      read(mae,produc);
      //busco en el maestro si no es el actual
      while(produc.codProd <> min.codProd)do
        begin
          read(mae,produc);
        end; 
      //si hay mas de uno en el detalle debo iterar y restar
      while (min.codProd = produc.codProd)do
        begin
          produc.stockD := produc.stockD - min.cantVen; 
          minimo(vec_det,vec_reg,min);
        end; 
      // cuando salgo debo actualizar en el maestro
      seek(mae,filepos(mae)-1);
      write(mae,produc);
    end; 
  close(mae);
  //tengo que hacer close a los 30 detalles
  for i:= 1 to 30 do
    begin
      close(vec_det[i]);
    end; 
end; 

procedure exportarMinimos(var mae : maestro);
var
  txt: text; 
  reg: producto;
begin
  reset(mae);
  assign(txt,'minimos.txt');
  rewrite(txt);
  while(not eof(mae))do
    begin
      read(mae,reg);
      if (reg.stockD<reg.stockM)then
        writeln(txt,reg.nomProd);
        writeln(txt,reg.stockD,' ',reg.precio, ' ',reg.descripcion);
    end; 
  close(mae);
  close(txt);
end; 

{---PROGRAMA PRINCIPAL----}
var
    mae:maestro;
    i: integer; 
    vec_det: vec_detalle; 
    vec_reg: vec_registro ; 
    istr: String;
begin
    assign(mae,'maestro');
    for i:= 1 to 30 do
    begin
      Str(i,istr);  //convierte un valor numerico en una cadena de caracteres
      assign(vec_det[i],'detalle'+ istr);
    end; 
    actualizar(mae,vec_det,vec_reg);
    exportarMinimos(mae);
end.
