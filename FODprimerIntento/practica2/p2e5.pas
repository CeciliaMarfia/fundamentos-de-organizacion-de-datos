{Se cuenta con un archivo de productos de una cadena de venta de alimentos congelados. De cada producto se almacena: código del producto, nombre, descripción, stock disponible,
stock mínimo y precio del producto.
Se recibe diariamente un archivo detalle de cada una de las 30 sucursales de la cadena. 
* Se debe realizar el procedimiento que recibe los 30 detalles y actualiza el stock del archivo maestro.
*  La información que se recibe en los detalles es: código de producto y cantidad vendida. 
* Además, se deberá informar en un archivo de texto: nombre de producto, descripción, stock disponible y 
* precio de aquellos productos que tengan stock disponible por debajo del stock mínimo. 
* Pensar alternativas sobre realizar el informe en el mismo procedimiento de actualización, 
* o realizarlo en un procedimiento separado (analizar ventajas/desventajas en cada caso).}
program p2e5;
uses
	sysutils; //para poder usar intoStr y convertir la i en string
const
	fin =30;
	valoralto= 9999;
type
	cadena30 = string[30];
	rangoVec = 1..fin;
	
	//registro del maestro
	producto = record
		codProd: integer;
		nombre: cadena30;
		descripción:cadena30;
		stockDisponible:integer;
		stockMinimo:integer;
		precio:real;
	end;
	
	//registro del detalle
	datoDet = record
		codProd: integer;
		cantVendida:integer;
	end;
	
	maestro = file of producto;
	detalle = file of datoDet;
	
		//vector de archivo detalle
		vectorArchDet = array [rangoVec] of detalle;
		
		//vector de registros de detalle
		vectorRegD = array[rangoVec] of datoDet;
	end;
//------------FIN DEL TYPE-------------------
procedure  cargarArchivoDetalle(var vectorArch: vectorArchDet;var vectorDetalle:vectorRegD);
var
	dato,min:datoDet;
	i:integer;
begin
	for i:=1 to fin do begin
		assign(vectorArch[i],'archivoDetalle'+intoStr(i)); //le mando el vector en la posicion que voy a almacenar;
		reset(vectorArch[i]); //porque ya dispongo de los detalles
		read(vectorArch[i],vectorDetalle[i]); //cargo el vector
	end;
	
	minimo(vectorDetalle,vectorArch,min);
	
	for i:=1 to fin do
		close(vectorArch[i]);
end;

procedure leer(var archivo: detalle; var dato:datoDet);

begin
 if (not eof(archivo))then
	read (archivo,dato)
 else
	dato.codProd:= valoralto;
end;

procedure minimo(var vectorRDetalle:vectorRegD;var vectorArch:vectorArchDet; var min:datoDet);
var 	
	i,posMin: integer;
begin
	min.codigo := -1;
	for i := 1 to fin do begin
		if (vectorRDetalle[i].codigo < min.codigo) then
			min:=vectorRDetalle[i];
			posmin:=i;
		end;
	end;
	leer(vectorArch[posMin], vectorRDetalle[posMin]);
end;

procedure actualizar();
begin
	while (min.cod <> valoralto) do begin
		read(mae1,regm);
		while (regm.cod <> min.cod) do
			read(mae1,regm);
		while (regm.cod = min.cod ) do begin
			regm.cant:=regm.cant - min.cantvendida;
			minimo(regd1, regd2, regd3, min);
		end;
	seek (mae1, filepos(mae1)-1);
	write(mae1,regm);








end;
//------------PROGRAMA PRINCIPAL-------------------
var
	mae:producto;
	det:datoDet;
	vec:vectorArchDet;
	vectorReg: vectorRegD;
begin
	cargarArchivoDetalle(vec,vectorR);
	actualizar();
end.
