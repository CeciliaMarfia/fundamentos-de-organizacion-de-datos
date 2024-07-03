{4. A partir de información sobre la alfabetización en la Argentina, se necesita actualizar un
archivo que contiene los siguientes datos: nombre de provincia, cantidad de personas
alfabetizadas y total de encuestados. Se reciben dos archivos detalle provenientes de dos
agencias de censo diferentes, dichos archivos contienen: nombre de la provincia, código de
localidad, cantidad de alfabetizados y cantidad de encuestados. Se pide realizar los módulos
necesarios para actualizar el archivo maestro a partir de los dos archivos detalle.
NOTA: Los archivos están ordenados por nombre de provincia y en los archivos detalle
pueden venir 0, 1 ó más registros por cada provincia.}
program ej4p3;
const
    valorAlto = 'zzzz';
type
    main = record
        nomProv:string;
        cantAlf:integer;
        totalEnc:integer;
    end;

    agencia =record
        nomProv:string;
        codLoc:integer;
        cantAlf:integer;
        cantEnc:integer;
    end;
    maestro = file of main;
    detalle = file of agencia;
{---FIN DEL TYPE----}
procedure leerDetalle(var det: detalle; var ag:agencia);
begin
    if(not eof(det)) then
        read(det,ag)
    else
        ag.nomProv:= valorAlto;
end;
procedure minimo(var ag1: agencia; var ag2: agencia; var min: agencia; var det1: detalle;  var det2 : detalle);
begin
  if (ag1.nomProv <ag2.nomProv)then
    begin
      min:= ag1; 
      leerDetalle(det1, ag1);
    end
  else 
    min:= ag2;
    leerDetalle(det2,ag2);
end; 

procedure actualizar(var mae:maestro; var det1:detalle; var det2:detalle);
var
    m:main;
    ag1,ag2,min:agencia;
begin
    reset(mae);
    reset(det1);
    reset(det2);
    read(mae,m);
    leerDetalle(det1,ag1);
    leerDetalle(det2,ag1);
    minimo(ag1,ag2,min,det1,det2);
    while(min.nomProv <> valorAlto)do begin
        while(min.nomProv <> m.nomProv) do
            read(mae,m);
            while(min.nomProv = m.nomProv) do begin 
                m.cantAlf:= m.cantAlf + min.cantAlf;
                m.totalEnc:= m.totalEnc + min.cantEnc;
                minimo(ag1,ag2,min,det1,det2);
            end;
            seek(mae,filepos(mae)-1);
            write(mae,m);
    end;
    close(mae);
    close(det1);
    close(det2);
end;

{---PROGRAMA PRINCIPAL----}
var
  mae: maestro;
  det1,det2 : detalle; 
BEGIN
  assign(mae,'maestro');
  assign(det1,'detalle1');
  assign(det2,'detalle2');
  actualizar(mae,det1,det2);
end.
