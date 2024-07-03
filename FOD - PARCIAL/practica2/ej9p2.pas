{9.Se necesita contabilizar los votos de las diferentes mesas electorales registradas por
provincia y localidad. Para ello, se posee un archivo con la siguiente información: código de
provincia, código de localidad, número de mesa y cantidad de votos en dicha mesa.
Presentar en pantalla un listado como se muestra a continuación:
* 
* 
Código de Provincia
Código de Localidad               Total de Votos
................................ ......................
................................ ......................
Total de Votos Provincia: ____


Código de Provincia
Código de Localidad                Total de Votos
................................ ......................
Total de Votos Provincia: ___


…………………………………………………………..
Total General de Votos: ___   
NOTA: La información está ordenada por código de provincia y código de localidad.
}
program ej9p2;
const
    valorAlto = 9999;
type
    voto= record
        codProv:integer;
        codLoc:integer;
        nroMesa:integer;
        cantVotos:integer;
    end;

    archivo = file of voto;
{---FIN DEL TYPE----}
procedure leerArchivo(var arch:archivo; var vot:voto);
begin
    if (not eof(arch)) then
        read(arch,vot)
    else
        vot.codProv:= valorAlto;
end;
procedure contarVotos(var arch:archivo);
var
    vot:voto;
    total,totalProv,totalCiudad:integer;
    prov,loc:integer;
begin
    reset(arch);
    leerArchivo(arch,vot);
    total:=0; //inicializo el total general
    while(vot.codProv <> valorAlto) do begin //mientras no llegue al fin d archivo
        prov:=vot.codProv;
        totalProv:=0;
        writeln('Código de Provincia');
        while(vot.codProv = prov) do begin //mientras no llegue al fin de provincia
            loc:=vot.codLoc;
            totalCiudad:=0;
            while (vot.codProv = prov) and (vot.codLoc <> loc) do begin //mientras no llegue al fin de ciudad
                totalCiudad:= totalCiudad+ vot.cantVotos;
                leerArchivo(arch,vot); //para que no quede en bucle procesando siempre lo mismo
            end;
            writeln('Codigo localidad: ', loc, 'Total de Votos Localidad: ',totalCiudad);
            totalProv:=totalProv+vot.cantVotos;
        end;
        writeln('Codigo provincia: ', prov, 'Total de Votos Provincia: ',totalProv);
		total:= total+ totalProv;
	end;
    writeln('Total General de Votos: ',total);
	close(arch);
end;
{---PROGRAMA PRINCIPAL----}
var
    arch: archivo;
begin
    assign(arch, 'archivo_votos');
    contarVotos(arch);
end.
