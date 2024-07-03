{6.Suponga que trabaja en una oficina donde está montada una LAN (red local). La misma fue
construida sobre una topología de red que conecta 5 máquinas entre sí y todas las
máquinas se conectan con un servidor central. Semanalmente cada máquina genera un
archivo de logs informando las sesiones abiertas por cada usuario en cada terminal y por
cuánto tiempo estuvo abierta. Cada archivo detalle contiene los siguientes campos:
cod_usuario, fecha, tiempo_sesion. Debe realizar un procedimiento que reciba los archivos
detalle y genere un archivo maestro con los siguientes datos: cod_usuario, fecha,
tiempo_total_de_sesiones_abiertas.
* 
Notas:
● Cada archivo detalle está ordenado por cod_usuario y fecha.
● Un usuario puede iniciar más de una sesión el mismo día en la misma máquina, o
inclusive, en diferentes máquinas.
● El archivo maestro debe crearse en la siguiente ubicación física: /var/log.}
program e6p2;
const
  valorAlto = 9999;
  dimf = 5;  
type
    //la mejor forma es hacerlo con un reg fecha
    //fechaa = record
    //  dia : integer; 
    //  mes : integer; 
    //  anio: integer; 
    //end; 
  
  infoDetalle = record
    cod : integer; 
    fecha  : integer; //fechaa; 
    tiempo_sesion : real ; 
  end; 
  
  infoMaestro = record
    cod : integer; 
    fecha : integer; //fechaa; 
    tiempo_total_de_sesiones_abiertas : real ; 
  end; 

    maestro = file of infoMaestro;
    detalle = file of infoDetalle;
    vecDetalle = array[1..dimf] of detalle;
    vecReg = array[1..dimf] of infoDetalle; 
type
{---FIN DEL TYPE----}
procedure leerDetalle(var det:detalle; var regD:infoDetalle);
begin
    if(not eof(det)) then
      read(det,regD)
    else
        regD.cod:=valorAlto
end;
procedure minimo(var vecD:vecDetalle ;var vecR:vecReg; var min:infoDetalle);
var
    i,indice:integer;
begin
    min.cod := 9999999;
    min.fecha := 999999;
    for i:=1 to dimf do begin
        if(vecR[i].cod < min.cod) then begin
            if (vecReg[i].fecha < min.fecha) then begin
                indice:= i;
                min:=vecR[i];
            end;
        end;
    end;           
//una vez que tengo un minimo actualizo en esa pos el proximo elemento, si no es valor alto 
  if(min.cod <> valorAlto)then
        leerDetalle(vecD[indice],vecR[indice])

end;

procedure leerMaestro(var mae:maestro; var regM:infoMaestro);
begin
   if(not eof(mae)) then
      read(mae,regM)
    else
        regM.cod:=valorAlto
end;
procedure crearMaestro(var mae:maestro;var vecD:vecDetalle;var vecR:vecReg);
var
    regM:infoMaestro;
    min:infoMaestro;
    i,cact:integer;
begin
    rewrite(mae); //creo el archivo maestro
    for i:=1 to 5 do begin 
        reset(vecD[i]); //abro los 5 archivos detalle
        leerDetalle(vecD[i], vecR[i]); // leo los 5 registros de los 5 archivos detalle
    end;
    minimo(vecD, vecR, min); //calculo el mínimo
  //merge
  while (min.cod <> valorAlto)do begin 
      //guardo el codigo actual 
      cact:= min.cod; 
      while (min.cod = cact)do begin
          //guardo la fecha que voy a iterar
          fact:= min.fecha;
          // copiamos un usario y ahora juntamos todas sus sesiones en UNA fecha
          regM.cod:= min.cod;
          regM.fecha:= min.fecha;
          regM.tiempo_total_de_sesiones_abiertas:= min.tiempo_sesion; 
          while((min.cod <> valorAlto)and (min.cod = cact)and(min.fecha = fact))do
            begin
              //mientras coincida la fecha suma la sesion y lee otro
              regM.tiempo_total_de_sesiones_abiertas:= regM.tiempo_total_de_sesiones_abiertas + min.tiempo_sesion;
              minimo(vecD,vecR,min);
            end; 
          //cuando sale es xq ya termino un archivo entonces debo agregarlo al maestro
          write(mae,regM);
        end; 
    end; 
  // como ya no trabajo mas con los archivos los cierro 
  close(mae);
  for i:= 1 to dimf do 
    begin
      close(vecD[i]);
    end;
end; 
{---PROGRAMA PRINCIPAL----}
var
    mae:maestro;
    vecD:vecDetalle;
    vecR:vecReg;
    i:integer;
    istr:string;
begin
    assign(mae,'maestro');
     for i:= 1 to dimf do begin
         Str(i,istr);  //convierte un valor numerico en una cadena de caracteres
         assign(vecD[i],'detalle' +istr);
    end;
    crearMaestro(mae,vecD,vecR);
end.