pico-8 cartridge // http://www.pico-8.com
version 32
__lua__
-- compas racer
-- by suterp & thegoose

function inicializaflecha()
 flecha=flr(rnd(3+dificultad))
end

function darnombrecorredor(i)
-- while corredor[i][5]==-1 do
--  corredor[i][5]=1+flr(rnd(#nombrecorredor))
--  for j=1,i-1 do
--   if corredor[i][5]==corredor[j][5] then
--    corredor[i][5]=-1
--   end
--  end
-- end
 corredor[i][5]=corredor[i][4]
end

function darsprcorredor(i)
 while corredor[i][4]==-1 do
  corredor[i][4]=1+flr(rnd(numcorredores))
  for j=1,i-1 do
   if corredor[i][4]==corredor[j][4] then
    corredor[i][4]=-1
   end
  end
 end
end

function dibujarcoche(ncorredor)

 x=corredor[ncorredor][1]
 y=corredor[ncorredor][2]
 paso=corredor[ncorredor][3]
 numspr=corredor[ncorredor][4]
 nombre=nombrecorredor[corredor[ncorredor][5]]

 palt(0,false) --elige rosa como transparente
 palt(14,true)

 if modo==1 then --estamos en el menu
	 x=(ncorredor-1)*14
	 y=64+flr(ncorredor%2)*8
	 paso=1
  if ncorredor==jugador then
   sspr(sprcoche[paso][1],sprcoche[paso][2],24,16,x-8,y)
   x=58
   y=16
  end
	elseif modo==4 then --estamos en los resultados
	 paso=1
	 if ncorredor==primero then
	  x=56
	  y=53
	 elseif ncorredor==segundo then
	  x=40
	  y=56
	 elseif ncorredor==tercero then
	  x=72
	  y=57
	 else --cuarto coche en los resultados (no dibuja)
	  return
	 end
 end

 --de vez en cuando sube un pixel
 if modo==2 and rnd(40)<2 then
  y=y-1
 end

 --parpadea el coche elegido en el menu
 if (ncorredor==jugador and modo==1) then 
  if rnd(2)<1 then turbo=1 else turbo=0 end
 end

 --dibujar corredor, cambiando a veces la cara
 if caracorredor[numspr]==1
 then
  sspr(sprcorredor[numspr][1],sprcorredor[numspr][2],16,16,x,y-2)
 	if rnd(200)<1 then caracorredor[numspr]=2 end
 else
  sspr(spr2corredor[numspr][1],spr2corredor[numspr][2],16,8,x,y-2)
  sspr(sprcorredor[numspr][1],sprcorredor[numspr][2]+8,16,8,x,y-2+8)
 	if rnd(80)<1 then caracorredor[numspr]=1 end
 end

 --dibujar coche
 if turbo>0 and ncorredor==jugador then
  sspr(sprcocheturbo[1],sprcocheturbo[2],24,16,x-8,y)
 else
  sspr(sprcoche[paso][1],sprcoche[paso][2],24,16,x-8,y)
 end
 palt(0,true)
 palt(14,falase)

 --dibujarnombre
 if modo==1 then --estamos en el menu
  if ncorredor==jugador then
	  color=7
   print(nombre,x+4-#nombre*2,y+17,color)
		end
 else
  color=6
	 if ncorredor==jugador then
	  color=7
	 end
  if modo!=4 then
    print(nombre,x+4-#nombre*2,y+17,color)
  end
 end
 
 --en carrera, indica exitos sucesivos
 if modo==2 and ncorredor==jugador and terminado[jugador]==false then
  textopuntosacumulados=puntosacumulados
  if bonus>0 then
   textopuntosacumulados="bonus"
   bonus-=1
  end
  printborde(textopuntosacumulados,x+20,y+1,8)
  --print(textopuntosacumulados,x+20,y+2,0)
  --print(textopuntosacumulados,x+20,y+0,0)
  --print(textopuntosacumulados,x+19,y+1,0)
  --print(textopuntosacumulados,x+21,y+1,0)
  --print(textopuntosacumulados,x+20,y+1,8)
 end

end

function dibujarvegetacion(numvegetacion)
 palt(0,false) --elige carne como transparente
 palt(15,true)
 numsprveg=vegetacion[numvegetacion][1]
 xveg=vegetacion[numvegetacion][2]
 yveg=vegetacion[numvegetacion][3]
 sspr(
  sprarbol[numsprveg][1],
  sprarbol[numsprveg][2],
	 16,
	 alturavegetacion[numsprveg]*8,
	 xveg,
	 posicionvegetacion[yveg]+((3-alturavegetacion[numsprveg])*8)
	 )
 palt(0,true) --elige carne como opaco
 palt(15,false)
end

function dibujarlineavegetacion(linea)
	for m=1,nvegetacion do
	 if vegetacion[m][3]==linea then
		 dibujarvegetacion(m)
		end
	end
end

function dibujarflecha(brillo)
 if turbo==0 then
	 direccion=flecha+1
	 if brillo==false then
	  sprx=sprflecha[direccion][1]
	  spry=sprflecha[direccion][2]
	 else
	  sprx=sprflechabrillo[direccion][1]
	  spry=sprflechabrillo[direccion][2]
	 end
  if banderaencendida==true and banderapirata==true then
    sprx=sprflechafalsa[direccion][1]
    spry=sprflechafalsa[direccion][2]
  end
	 --dibuja la flecha a la izda. del jugador
	 sspr(
	  sprx,spry,
	  8,8,
	  corredor[jugador][1]-24,
	  corredor[jugador][2]+8)
	 --dibuja la flecha a la dcha. del jugador
	 sspr(
	  sprx,spry,
	  8,8,
	  corredor[jugador][1]+32,
	  corredor[jugador][2]+8)
 end
end

function drawportada()
 map(48,0,0,0,16,16)
 printcenterborde(texto[1][idioma],44,7+pasoportada%2)
 printcenter(texto[47][idioma],51,7)
 printcenter(texto[2][idioma],58,10)

 printcenterborde(texto[17][idioma],110,7)
 printcenterborde(texto[18][idioma],118,7)

 if idioma==1 then
  printcenter(texto[3][idioma],73,2)
 printcenter(">"..texto[4][idioma].."<",82,8)
 else
  printcenter(">"..texto[3][idioma].."<",73,8)
  printcenter(texto[4][idioma],82,2)
 end

 sspr(sprflecha[1][1],sprflecha[1][2],8,8,6,117)
 sspr(sprflecha[2][1],sprflecha[2][2],8,8,16,117)
 sspr(sprflecha[3][1],sprflecha[3][2],8,8,26,117)
 sspr(sprflecha[4][1],sprflecha[4][2],8,8,36,117)
 
 sspr(sprflecha[5][1],sprflecha[4][2],8,8,89,117)
 sspr(sprflecha[6][1],sprflecha[4][2],8,8,106,117)


 --dibuja el coche
 x=pasoportada
 y=21
 if (rnd(15)<1) then y=y-1 end
 --sspr(48,16,24,16,x-8,y)
 npaso=flr(pasoportada%3)+1
 palt(14,true)
 palt(0,false)
 sspr(sprcorredor[spriteportada][1],sprcorredor[spriteportada][2],16,16,x,y-3)
 if caracorredor[spriteportada]>1 then sspr(spr2corredor[spriteportada][1],spr2corredor[spriteportada][2],16,8,x,y-3) end
 sspr(sprcoche[npaso][1],sprcoche[npaso][2],24,16,x-8,y)
 palt(14,false)
 palt(0,true)

 --cambia a veces de cara
 if caracorredor[spriteportada]==1
 then
 	if rnd(100)<1 then caracorredor[spriteportada]=2 end
 else
 	if rnd(40)<1 then caracorredor[spriteportada]=1 end
 end
 
 pasoportada-=1
 if pasoportada==-24 then
   pasoportada=129
   spriteportada=spriteportada+1
   if spriteportada>numcorredores then spriteportada=1 end
   end

 
end

function updateportada()
 if btn(2) then idioma=2 end
 if btn(3) then idioma=1 end
 if btn(4) or btn(5) then
   while btn(4) or btn(5) do
    flip()
   end
  initmenu()
  end
end

function _init()
 --modos: 0 - portada, 1 - portada, 2 - carrera
 modo=0
 music(14)
  
 --textos
 idioma=1
 texto={{}}
 texto[1]={"c o m p a s   r a c e r","c o m p a s   r a c e r"}
 texto[2]={"pulsa un boton para continuar","press any button to continue"}
 texto[3]={"ingles","english"}
 texto[4]={"castellano","spanish"}
 texto[5]={"elige corredor","select a racer"}
 texto[6]={"dificultad","difficulty"}
 texto[7]={"preparados","ready"}
 texto[8]={"listos","set"}
 texto[9]={"!ya!","go!"}
 texto[10]={"ganadores - ronda ","winners - round "}
 texto[11]={"pulsa cualquier boton","press any button"}
 texto[12]={"para moverte hacia delante","to move your car forward"}
 texto[13]={"pulsa la tecla del icono","press the same key as"}
 texto[14]={"que aparece a tu lado","the icon by your side"}
 texto[15]={"ganador","winner"}
 texto[16]={"segundo","second"}
 texto[17]={"teclas","key mapping"}
 texto[18]={
  "         cursores     z   x",
  "         arrow keys   z   x"}
 texto[19]={"segunda ronda","second round"}
 texto[20]={"se comienza a usar el boton 🅾️","button 🅾️ is now in use"}
 texto[21]={"ultima ronda","last round"}
 texto[22]={"ronda","round"}
 texto[23]={"ahora utilizamos 🅾️ y ❎","now we use both 🅾️ and ❎"}
 texto[24]={" de 3"," of 3"} 
 texto[25]={"ganador","winner"}
 texto[26]={"segundo","second"}
 texto[27]={"tercero","third"}
 texto[28]={"puntos","points"}
 texto[29]={"enhorabuena: eres el ganador","congratulations: you win"}
 texto[30]={"has quedado segundo","second place"}
 texto[31]={"has quedado tercero","third place"}
 texto[32]={"mejor suerte en la proxima","better luck next time"}
 texto[33]={"seg","sec"}
 texto[34]={"record actual: ","current record: "}
 texto[35]={" puntos ("," points ("}
 texto[36]={" seg.)"," sec.)"}
 texto[37]={"!nuevo record!","new record!"}
 texto[38]={"te has fijado en la bandera?","have you notticed the flag?"}
 texto[39]={"nombre: ","name: "}
 texto[40]={"segunda vuelta","second lap"}
 texto[41]={"las carreras se juegan","races consist of"}
 texto[42]={"a tres rondas de dos vueltas","three rounds of two laps"}
 texto[43]={"corriendo cada vez mas rapido","faster each time"}
 texto[44]={"cuando veas la bandera pirata","when you see the pirate flag"}
 texto[45]={"piensa al reves","think backwards"}
 texto[46]={"presta atencion al sonido","pay attention to the sound"}
 texto[47]={"por suterp y thegoose","by suterp & thegoose"}
 texto[48]={"hasta ahora: ","so far: "}
 texto[49]={"tus resultados: ","your results: "}

 --nombres de los corredores
 nombrecorredor={
  "rius play",
  "mikecrack",
  "invictor",
  "eltrollino",
  "sparta",
  "elmayo97",
  "timba vk",
  "mike.exe",
  "raptorgamer"
  }
 caracorredor={1,1,1,1,1,1,1,1,1}

 --sprites (corredores, coches, vegetacion, flechas...)
 numcorredores=9
 sprcorredor={{8,0},{8,16},{80,16},{112,16},{80,96},{96,96},{80,112},{96,112},{0,32}}
 spr2corredor={{40,56},{56,56},{72,56},{88,56},{112,96},{112,104},{112,112},{112,120},{16,32}}
 sprcoche={{24,16},{48,0},{24,0}}
 sprcocheturbo={48,16}
 vueltacorredor={1,1,1}
 nsprarbol=8
 sprarbol={{0,48},{16,48},{32,32},{48,40},{64,48},{80,48},{96,40},{112,40}}
 sprflecha={{0,72},{16,72},{24,72},{8,72},{32,72},{40,72}} 
 sprflechafalsa={{0,64},{16,64},{24,64},{8,64},{32,64},{40,64}} 
 sprflechabrillo={{0,80},{16,80},{24,80},{8,80},{32,80},{40,80}}
 sprronda={{0,88},{8,88},{16,88}}
 sprronda2={{24,88},{32,88},{40,88}}
 sprbandera={
  {0,96},{16,96},{32,96},
  {0,112},{16,112},{32,112}}
 sprbanderaencendida={
  {48,96},{48,112}}
 sprbanderaencendida2={
  {64,96},{64,112}}
 
 --datos de la vegetacion
 nposicionvegetacion=4
 posicionvegetacion={7,31,55,80}
 alturavegetacion={1,1,3,2,1,1,2,2}
 nvegetacion=8
 vegetacion={{}}
 
 --dibujar coche en modo turbo
 turbo=0
 
 ---letras para los records
 letrasrecord="abcdefghijklmnopqrstuvwxyz0123456789!?-."
 
 --sprite para la portada
 pasoportada=80
 spriteportada=1+flr(rnd(numcorredores))

 --record actual
 cartdata("compas_racer")

--descomentar para reiniciar
--  dset(0,10)
--  dset(1,120)
--  dset(2,1)
--  dset(3,1)
--  dset(4,1)

 recordpuntos=dget(0)
 recordsegundos=dget(1)
 recordnombre1=dget(2)
 recordnombre2=dget(3)
 recordnombre3=dget(4)
 if recordpuntos==0 then recordpuntos=10 end
 if recordsegundos==0 then recordsegundos=120.0 end
 if recordnombre1==0 then recordnombre1=1 end
 if recordnombre2==0 then recordnombre2=1 end
 if recordnombre3==0 then recordnombre3=1 end
 recordnombre=
  sub(letrasrecord,recordnombre1,recordnombre1)..
  sub(letrasrecord,recordnombre2,recordnombre2)..
  sub(letrasrecord,recordnombre3,recordnombre3)
end

function initmenu()
 modo=1
 music(11)
 
 --datos de cada corredor
 ncorredores=numcorredores
 posiciony={24,48,72}
 corredor={}
 --inicializa los corredores
 for i=1,ncorredores do
  caracorredor[i]=1
  if rnd(20)<2 then caracorredor[i]=2 end
  corredor[i]={
   -1, --x
   posiciony[i], --y
   1+flr(rnd(3)), --paso
   -1, --spr
   i, --nombre
   0, --puntuacion
   0 } --segundos acumulados
  darsprcorredor(i)
  darnombrecorredor(i)
 end  

 --numero de corredor que es el jugador
 jugador=5
end 

function drawmenu()
 map(48,0,0,0,16,16)
 for n=1,ncorredores do
  dibujarcoche(n)
 end
 printcenterborde(texto[5][idioma],4,7)
 printcenterborde(texto[34][idioma],110,6)
 printcenterborde(recordnombre.." - "..recordpuntos..texto[35][idioma]..adecimales(recordsegundos)..texto[36][idioma],118,8)
end

function updatemenu()
 if btn(0) then
  jugador-=1
  if jugador<1 then jugador=numcorredores end
 elseif btn(1) then
  jugador+=1
  if jugador>numcorredores then jugador=1 end
 end
 
 while btn(1) or btn(2) or btn(3) or btn(0) do
  flip()
 end
 
 if btn(4) or btn(5) then
  while btn(4) or btn(5) do flip() end
  dificultad=1
  initcarrera()
 end
 
end

function initcarrera()
 modo=2
 music(-1)
 
 ncorredores=3
 vueltacorredor={1,1,1}
 nmensaje=1
 puntosacumulados=0
 bonus=0
 
 if jugador>3 then --si no somos uno de los tres primeros, nos coloca en una posicion del uno al tres, ya que son los que van a jugar
   nuevojugador=flr(1+rnd(3))
   corredor[nuevojugador][4]=corredor[jugador][4]
   corredor[nuevojugador][5]=corredor[jugador][5]
   jugador=nuevojugador
 end
 
 --inicializar corredores
 for i=1,ncorredores
 do
  corredor[i][1]=127
 end

 --semaforo: 4 (inicial), 3,2,1,0 empieza
 semaforo=4

 --iniicializar podium
 primero=-1
 segundo=-1
 tercero=-1
 
 --inicializa la posicion de la bandera
 posbandera=1
 banderaencendida=false
 banderapirata=false
 avanzar=true
 
 --indica si un jugador ha terminado
 terminado={false,false,false}

 --vegetacion[sprite,x,posiciony]
 for n=1,nvegetacion do
  vegetacion[n]={
   1+flr(rnd(nsprarbol)),
   flr(rnd(128)),
   1+flr(rnd(1+nposicionvegetacion))
   }
 end

 --contador de pasos (para scroll)
 contadorpasos=0

 --indicador de flecha actual
 --(0=iz,1=dc,2=ar,3=ab)
 flecha=-1
 inicializaflecha()
end

function _update()
 if modo==0 then
  updateportada()
 elseif modo==1 then
  updatemenu()
 elseif modo==2 then
  updatecarrera()
 elseif modo==3 then
  updatefincarrera()
 elseif modo==4 then
  updateresultados()
 end
end
 
function _draw()
 if modo==0 then
  drawportada()
 elseif modo==1 then
  drawmenu()
 elseif modo==2 then
  drawcarrera()
 elseif modo==3 then
  drawfincarrera()
 elseif modo==4 then
  drawresultados()
 end
end

function updatecarrera()

 if semaforo==0 then
	 --hacemos avanzar a todos los corredores
	 for n=1,ncorredores do
	  --si no ha terminado
	  if terminado[n]==false then
		  --para los no jugadores
		  if n!=jugador then
				 --cambia el numero de paso
			  corredor[n][3]+=1
				 if corredor[n][3]>3 then
				  corredor[n][3]=1
				 end
		   --avanza una de cada 4 veces
		   if rnd(4)<=1 then
		    --avanza segun la dificultad
			   corredor[n][1]-=rnd(1.4+dificultad/2.3)
			   --si el jugador principal ha avanzado, lo hacemos mas rapido
			   if terminado[jugador] then corredor[n][1]-=1 end
					end
		  end
		 end
		end 

	 if turbo>0 then --if1
	  --si estamos en modo turbo
	  if avanzar==false then
	    --en bandera pirata retrocedemos con limite al final
	    corredor[jugador][1]+=2+dificultad
   else
  	  --y si no avanzamos
  	  corredor[jugador][1]-=2+dificultad
	  end
	  turbo-=1
	  if turbo==0 then banderaencendida=false end
	 else	--else1
		 --si pulsamos la tecla, avanza nuestro corredor
	  if terminado[jugador]==false then --if2
			 for boton=0,5 do --for3
			  --comprueba cada boton
				 if btn(boton) and boton==flecha then --if4
				  dibujarflecha(true)
				  puntosacumulados+=1
				  if puntosacumulados==10 then
				   puntosacumulados=0
				   corredor[jugador][6]+=1
				   sfx(6)
				   bonus=15
				  else
				   sfx(0)
				  end
			   if banderaencendida==true then --if5
 			   --si la bandera esta encendida, empezamos un turbo
 			   turbo=10
-- 			   if banderapirata==false then
		      avanzar=true
 			    sfx(26)
-- 			   else
-- 			    --avanzar=false
-- 			    avanzar=true
-- 			    sfx(27)
-- 			   end
 			  else	--elseif5
			    --si no, hacemos el avance normal
		 		  corredor[jugador][1]-=3+flr(rnd(4))
					  --cambia el numero de pasos
					  corredor[jugador][3]+=1
						 if corredor[jugador][3]>3 then --if6
						  corredor[jugador][3]=1
						 end --endif6
					  --espera a que se deje de pulsar
					  while btn(boton) do --while7
					   flip()
					  end --endwhile7
					  inicializaflecha()
					 end --endif5
				 else --else4
			   --si hemos pulsado el boton adecuado
			   --pero no tocaba...
			   if btn(boton) then --if8
			 	  dibujarflecha(true)
			 	  if corredor[jugador][1]<127 then --if9
	 		    if banderaencendida==false then
  			 	  sfx(1)
  			 	  puntosacumulados=0
 	 		    corredor[jugador][1]+=5
 	 		   else
 	 		    --si la bandera estaba encendida, retrocede mas
         sfx(27)
 	 		    corredor[jugador][1]+=10
 	 		   end
	 		    flip()   
	 		   end --endif9
			   end --endif8
     end --endif4
				end --endfor3
		 end --endif2
  end --endif1

  --controla si nos hemos pasado llevando a la derecha al jugador
  if corredor[jugador][1]>127 then
   corredor[jugador][1]=127
  end


  --avanza la bandera
  if banderaencendida==false then
   if rnd(200)<1 then
    banderaencendida=true
    banderapirata=false
    if dificultad>1 and rnd(2)<1 then
     --a partir de la primera ronda se puede encender la pirata
     banderapirata=true
    end
    if banderapirata==true then
     sfx(29)
    else
     sfx(28)
    end
   else
    if rnd(8)<1 then posbandera+=1 end
    if posbandera==7 then posbandera=1 end
   end
  else
   if rnd(150)<1 then banderaencendida=false end 
  end
  
	 --avanza la vegetacion
  for n=1,nvegetacion do --avantaza toda la vegetacion 1 punto
   vegetacion[n][2]+=dificultad
  end
	 contadorpasos+=dificultad
	 if contadorpasos>=3 then
	  for n=1,nvegetacion do
	   vegetacion[n][2]+=1
	   if vegetacion[n][2]>128 then
	     vegetacion[n][1]=1+flr(rnd(nsprarbol))
	     vegetacion[n][2]=-20
	     vegetacion[n][3]=1+flr(rnd(1+nposicionvegetacion))
	   end
	  end
	  contadorpasos=0
	 end

  --comprueba si alguno ha ganado
  for n=1,numcorredores do
   if corredor[n][1]<1 and terminado[n]==false then
		  --terminamos y contamos los segundos acumulados
    if vueltacorredor[n]<2 then
     if corredor[n][1]<-16 then
      vueltacorredor[n]+=1
      corredor[n][1]=130
     end
    else
	    terminado[n]=true
	    corredor[n][7]+=time()-contadortiempo
	    if primero==-1 then
	     sfx(18)
	     primero=n
	   	 tiempoprimero=time()-contadortiempo
	    elseif segundo==-1 then
	     sfx(18)
	     segundo=n
	   	 tiemposegundo=time()-contadortiempo
	    else
	     tercero=n
	     for m=1,numcorredores do
	      if terminado[m]==false then
	       --al ultimo le contamos 5 segundos mas
	       corredor[m][7]+=5+time()-contadortiempo
	      end
	     end
	     initfincarrera()
	    end
	   end
   end
  end
 
  else
 
  if semaforo==4 then
   if btn(4) or btn(5) then
    if nmensaje==1 and dificultad<3 then
     while btn(4) or btn(5) do
      flip()
     end
     nmensaje=2
    else
     nmensaje=1
     semaforo=3
    end
   end
  else
	  if semaforo>1 then
	   sfx(2)
	  else
	   sfx(3)
	  end
	  for i=1,25 do
	   flip()
	  end
	  semaforo-=1
	  if	semaforo==0 then
	   --empieza la carrera
	   music(18)
	   contadortiempo=time()
	   end
	 end
 end
end

function drawcarrera()

 palt(0,false) --elige carne como transparente
 palt(15,true)
 map(0,0,0,0,16,16)
 palt(0,true) --elige negro como transparente
 palt(15,false)

 dibujarbandera()
 
 for n=1,ncorredores do
  if vueltacorredor[n]>1 then
   print(texto[40][idioma],126-#texto[40][idioma]*4,10+24*n,0)
  end
  dibujarlineavegetacion(n)
  dibujarcoche(n)
 end
 dibujarlineavegetacion(ncorredores+1)

 if semaforo==4 then
  map(32,0,0,0,16,16)
  if dificultad==1 then
   if nmensaje==1 then
    printcenter(texto[12][idioma],38,7)
    printcenter(texto[13][idioma],50,7)
    printcenter(texto[14][idioma],62,7)
   else
    printcenter(texto[41][idioma],38,7)
    printcenter(texto[42][idioma],50,7)
    printcenter(texto[43][idioma],62,7)
   end
   printcenterborde(texto[2][idioma],76,8)
  elseif dificultad==2 then
   if nmensaje==1 then
    printcenter(texto[19][idioma],38,7)
    printcenter(texto[20][idioma],50,7)
    printcenter(texto[38][idioma],62,7)
   else
    printcenter(texto[46][idioma],38,7)
    printcenter(texto[44][idioma],50,7)
    printcenter(texto[45][idioma],62,7)
   end
   printcenterborde(texto[2][idioma],76,8)
  else
   printcenter(texto[21][idioma],46,7)
   printcenter(texto[23][idioma],58,7)
   printcenterborde(texto[2][idioma],76,8)
  end
 elseif semaforo==3 then
  circfill(64, 64, 34, 1)
  circfill(64, 64, 32, 8)
  clip(64,0,64,128)
  circfill(65, 64, 31, 7)
  clip(0,0,64,128)
  circfill(63, 64, 31, 2)
  clip()
  circfill(64, 64, 31, 8)
  printcenter(texto[7][idioma],62,7)
 elseif semaforo==2 then
  circfill(64, 64, 34, 1)
  circfill(64, 64, 32, 9)
  clip(64,0,64,128)
  circfill(65, 64, 31, 10)
  clip(0,0,64,128)
  circfill(63, 64, 31, 4)
  clip()
  circfill(64, 64, 31, 9)
  printcenter(texto[8][idioma],62,7)
 elseif semaforo==1 then
  circfill(64, 64, 34, 1)
  circfill(64, 64, 32, 3)
  clip(64,0,64,128)
  circfill(65, 64, 31, 11)
  clip(0,0,64,128)
  circfill(63, 64, 31, 5)
  clip()
  circfill(64, 64, 31, 3)
  printcenter(texto[9][idioma],62,7)
 else
  --la carrera ha empezado
  if terminado[jugador]==false then dibujarflecha(false) end
  dibujarronda()
  if primero!=-1 then
   if primero==jugador then color=8 else color=7 end
	  print(nombrecorredor[corredor[primero][5]]..": "..adecimales(tiempoprimero)..texto[33][idioma],8,110,color)
	  if segundo!=-1 then
    if segundo==jugador then color=8 else color=7 end
	  	print(nombrecorredor[corredor[segundo][5]]..": "..adecimales(tiemposegundo)..texto[33][idioma],8,120,color)
	  end
	 else
	   colorbonus=7+(bonus%2)
	   print(adecimales(time()-contadortiempo).." "..texto[33][idioma]..", "..corredor[jugador][6].." pts",8,110,colorbonus)
	 end
	end
end

function dibujarronda()
 print(texto[22][idioma],110-2*#texto[22][idioma],110,6)
 for n=1,3 do
  if dificultad!=n then
   sspr(sprronda[n][1],sprronda[n][2],8,8,90+n*8,117)
  else
   sspr(sprronda2[n][1],sprronda2[n][2],8,8,90+n*8,117)
  end
 end
end

function dibujarbandera()
 if banderaencendida==false then
  sspr(sprbandera[posbandera][1],sprbandera[posbandera][2],16,16,40,8)
 else
  nbandera=flr(rnd(2)+1)
  if banderapirata==false then
   sspr(sprbanderaencendida[nbandera][1],sprbanderaencendida[nbandera][2],16,16,40,8)
  else
   sspr(sprbanderaencendida2[nbandera][1],sprbanderaencendida2[nbandera][2],16,16,40,8)
  end
 end
end

function initfincarrera()
 modo=3
 turbo=0
 music(-1)
 sfx(17)
 corredor[primero][6]+=10
 corredor[segundo][6]+=6
 corredor[tercero][6]+=3
end

function drawfincarrera()
 map(16,0,0,0,16,16)
 colorprimero=6
 colorsegundo=6
 colortercero=6
 textoprimero=nombrecorredor[corredor[primero][5]]
 textosegundo=nombrecorredor[corredor[segundo][5]]
 textotercero=nombrecorredor[corredor[tercero][5]]
 if jugador==primero then
  colorprimero=8
  textoprimero=">"..textoprimero.."<"
 elseif jugador==segundo then
  colorsegundo=8
  textosegundo=">"..textosegundo.."<"
 elseif
  jugador==tercero then colortercero=8
  textotercero=">"..textotercero.."<"
 end
 printcenter(texto[10][idioma]..dificultad..texto[24][idioma],25,7)
 printcenter("1: "..textoprimero,40,colorprimero)
 printcenter("2: "..textosegundo,50,colorsegundo)
 printcenter("3: "..textotercero,60,colortercero)
 printcenter(texto[11][idioma],78,7)

 printcenter(texto[48][idioma]..flr(corredor[jugador][7])..texto[33][idioma]..", "..corredor[jugador][6].."pts",114,7)
end

function drawresultados()
 map(64,0,0,0,16,16)
 for n=1,numcorredores do
  dibujarcoche(n)
  if n==jugador then
   color=8
  else
   color=7
  end
	 if n==primero then
	  x=64
	  y=29
	  texto0=texto[25][idioma]
	 elseif n==segundo then
	  x=35
	  y=81
	  texto0=texto[26][idioma]
	 elseif n==tercero then
	  x=92
	  y=81
	  texto0=texto[27][idioma]
	 end
  if n==primero or n==segundo or n==tercero then
	  texto1=nombrecorredor[corredor[n][5]]
	  texto2=corredor[n][6].." "..texto[28][idioma]
	  if n==primero then
   	printborde(texto0,x-2*#texto0,y,color)
	   printborde(texto1,x-2*#texto1,y+8,color)
   else
   	print(texto0,x-2*#texto0,y,color)
	   print(texto1,x-2*#texto1,y+8,color)
	  end
	  print(texto2,x-2*#texto2,y+16,6)
	 end
 end
 
 if jugador==primero then
  texto1=texto[29][idioma]
 elseif jugador==segundo then
  texto1=texto[30][idioma]
 elseif jugador==tercero then
  texto1=texto[31][idioma]
 else
  texto1=texto[32][idioma]
 end
 printcenterborde(texto1,110,7) 

 if nuevorecord==true then
  printcenterborde(texto[37][idioma],6,8+flr(rnd(3)))
  postexto=64-2*(#texto[39][idioma]+4)
  print(texto[39][idioma],postexto,14,2)
  postexto+=#texto[39][idioma]*4
  recordnombre=""
  for l=1,3 do
   letrachar=sub(letrasrecord,letra[l],letra[l])
   if nletra==l then colorchar=8+flr(rnd(3)) else colorchar=2 end
   print(letrachar,postexto,14,colorchar)
   postexto+=4
   recordnombre=recordnombre..letrachar
  end
  if rnd(8)>1 then
   sspr(64,88,13,5,postexto-13,20)
   sspr(120,80,5,13,postexto+1,12)
  else
   sspr(80,88,13,5,postexto-13,20)
   sspr(120,64,5,13,postexto+1,12)
  end
  dset(0,recordpuntos)
  dset(1,recordsegundos)
  dset(2,letra[1])
  dset(3,letra[2])
  dset(4,letra[3])
 end
 printcenterborde(texto[49][idioma]..flr(corredor[jugador][7])..texto[33][idioma]..", "..corredor[jugador][6].."pts",118,7)

end

function updatefincarrera()
 if btn(4) or btn(5) then
   while btn(4) or btn(5) do
    flip()
   end
  if dificultad<3 then
   dificultad+=1
   initcarrera()
  else
   initresultados()
  end
 end
end

function initresultados()
 modo=4
 music(12)
 primero=-1
 segundo=-1
 tercero=-1

 for n=1,numcorredores do
  if primero==-1 then
   primero=n
  elseif corredor[n][6]>corredor[primero][6] then
   primero=n
  elseif corredor[n][6]==corredor[primero][6] then
	  --empate: contamos por segundos acumulados
   if corredor[n][7]<corredor[primero][7] then
    primero=n
   end
  end
 end
 for n=1,numcorredores do
  if n!=primero then
   if segundo==-1 then
    segundo=n
   elseif corredor[n][6]>corredor[segundo][6] then
    segundo=n
   elseif corredor[n][6]==corredor[segundo][6] then
		  --empate: contamos por segundos acumulados
    if corredor[n][7]<corredor[segundo][7] then
     segundo=n
    end
   end
  end
 end
 for n=1,numcorredores do
  if n!=primero and n!=segundo then
	  if tercero==-1 then
	   tercero=n
	  elseif corredor[n][6]>corredor[tercero][6] then
	   tercero=n
	  elseif corredor[n][6]==corredor[tercero][6] then
		  --empate: contamos por segundos acumulados
	   if corredor[n][7]<corredor[tercero][7] then
     tercero=n
    end
	  end
  end
 end
 
 if corredor[jugador][6]>recordpuntos or (corredor[jugador][6]==recordpuntos and corredor[jugador][7]<recordsegundos) then
  nuevorecord=true
  letra={1,1,1}
  nletra=1
  recordpuntos=corredor[jugador][6]
  recordsegundos=corredor[jugador][7]
 else
  nuevorecord=false
 end

end

function updateresultados()
 if btn(4) or btn(5) then
  while btn(4) or btn(5) do
   flip()
  end
  initmenu()
 elseif btn(0) then
  sfx(12)
  if nletra>1 then nletra-=1 end
  flip()
  flip()
  flip()
 elseif btn(1) then
  sfx(12)
  if nletra<3 then nletra+=1 end
  flip()
  flip()
  flip()
 elseif btn(2) then
  sfx(12)
  if letra[nletra]<#letrasrecord then letra[nletra]+=1 else letra[nletra]=1 end
  flip()
  flip()
  flip()
 elseif btn(3) then
  sfx(12)
  if letra[nletra]>1 then letra[nletra]-=1 else letra[nletra]=#letrasrecord end
  flip()
  flip()
  flip()
 end
end

function printcenter(texto,y,color)
 print(texto,64-2*#texto,y,color)
end

function printcenterborde(texto,y,color)
 print(texto,63-2*#texto,y,0)
 print(texto,65-2*#texto,y,0)
 print(texto,64-2*#texto,y-1,0)
 print(texto,64-2*#texto,y+1,0)
 print(texto,64-2*#texto,y,color)
end

function printborde(texto,x,y,color)
 print(texto,x-1,y,0)
 print(texto,x+1,y,0)
 print(texto,x,y-1,0)
 print(texto,x,y+1,0)
 print(texto,x,y,color)
end

function adecimales(n)
 entero=flr(n)
 decimales="."..flr(n%1*100)
 while #decimales<3 do
  decimales=decimales.."0"
 end
 return entero..decimales
end
__gfx__
00000000eeeeeeee88eeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeecccccccc5555555533333333ccccca9c9acccccc0000000022766682
00000000eeeeeee8888eeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeecccccccc5555555533333333ccca9caaaca9cccc0000000033333333
00000000eeeeeee88778eeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeecccccccc5555555533333333cc9caaaaaa9caccc0000000033333333
00070700eeeeeee756778eeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeecccccccc55555555333b3333cac9aaaaaaaac9cc0000000033333333
00007000eeeeeee977778eeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeecccccccc5555555533333333c9aaaaaaaaaa9acc0000000033333333
00070700eeeeee997776eeeeeeeeeeeeeeee5eeeeeeeeeeeeeeeeeeeeeee5eeeeeeeeeeecccccccc5555555533333333acaaaa777aaaac9c0000000033333333
00000000eeeeeeee676eeeeeeeeeeeeeeee80eeeeeee8eeeeeeeeeeeeee80eeeeeee8eeecccccccc55555555333333339aaaa77777aaaaac0000000033333333
00000000eeeeeeee69a9eeeeeeeeeeeeee880eeeeeee8eeeeeeeeeeeee880eeeeeee8eeecccccccc5555555533333333c9aaa77777aaaacc0000000033333333
22766682eeeee6699aaa9eeeeeeeeeeee8820eeeeee49e2eeeeeeeeee8820eeeeee49e2e3333333355765576333333339aaaa77777aaaa9c3333333333333333
35353535eeeee77aaaaa9eeeeeeeeeee8882eeeeee488255eeeeeeee8882eeeeee488255333333335555555533333333acaaaa777aaaacac3333333333333333
53535353eeeeeeee6aaaaeeeeeeeeee88888822222888255eeeeeee88888822222888255333333335555555533533333c9aaaaaaaaaaa9cc3333333333333333
35353535eeeeeeee75559eeeeeeeee8885508888880002eeeeeeee8880558888885502ee333333335555555533333333cac9aaaaaaa9cacc3333333333333333
53535353eeeee7955555eeeeeeeee98855700888800700eeeeeee98800705888850700ee333333335555555533333333cc9ca9aaaaac9ccc3333333333333333
35353535eeeee7a55555eeeeeeee698857650888807655eeeeee698807655888857650ee333333335555555533333333ccca9caa9c9acccc3333333333353533
53535353eeeeeeeeeeeeeeeeeeee222250500222200505eeeeee222200505222250500ee333333335555555533333333cccccac9a9cccccc3333333333333333
887777e8eeeeeeeeeeeeeeeeeeeeeeeee000eeeeee005eeeeeeeeeeee000eeeeee000eee333333335555555533333333cccccccccccccccc887777e833333333
55555555eeeeee4444eeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeee11111111eeeeeee88882eeeecccccccccccccccceeeeeee98e989eee
55555555eeeee4aa9a4eeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeee11111111eeeeeee000008eeecccccccccccccccceeeeeee999999eee
55555555eeeee994a949eeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeee11111111eeeeeee444008eeecccccccccccccccceeeeeee000099eee
55555555eeee9906a0694eeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeee11111111eeeeeee3ff008eeecccccccc7777776ceeeeeeecf5005eee
55555555eeee99aa0aa94eeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeee11111111eeeeeeefff002eeec7776ccccccccccceeeeeeeff5000eee
55555655eeeee9a988994eeeeeeeeeeeeeee5eeeeeeeeeeeeeeeeeeeeeee5eeeeeeeeeee11111111eeeeeee7ff77eeeecccccccccccccccceeeeeee7ff005eee
55555555eeeeeeeaaa94eeeeeeeeeeeeeee80eeeeeee8eeeeeeeeeeeeee70eeeeeee7eee11111111eeeeeeee0002eeeecccccccccccccccceeeeeeeeff00eeee
55555555eeeeeee99aaa33eeeeeeeeeeee880eeeeeee8eeeeeeeeeeeee770eeeeeee7eee11111111eeeeeeee75582eeecccccccccccccccceeeeeeeea994eeee
55665566eeeee9aaaaaa333eeeeeeeeee8820eeeeee49e2eeeeeeeeee7760eeeeee6ae6ecc66cc66eeeeeff4ff558eeecccccccccccccccceeeeefffa499eeee
55555555eeeee9aaa999533eeeeeeeee8882eeeeee488255eeeeeeee7776eeeeee67765511cc11cceeeeeff4ff558eeecccccccccccccccceeeeeffffa99eeee
55555555eeeeeeee99aa5333eeeeeee88888822222888255eeeeeee77777766666777655cc11cc11eeeeeeee55558eeecccc67777776cccceeeeeeeefa99eeee
55555555eeeeeeeeaaaaa533eeeeee8880008888880002eeeeeeee7770007777770006ee11111111eeeeeeee66558eeecc67777776cccccceeeeeeee8894eeee
55555555eeeeeaaaaaaa333eeeeee98805700888800700eeeeeeea7700700777700700ee11111111eeeee4f9f5558eeecccccccccccccccceeeee0fccc94eeee
55655555eeeeeaaaaaaaeeeeeeee698807650888807650eeeeeeaa7707650777707650ee11111111eeeee4f9f5558eeecccccccccccccccceeeee0fcccceeeee
55555555eeeeee9999eeeeeeeeee222250500222250500eeeeee666600500666600500ee11111111eeeeeeeeeeeeeeeecccccccccccccccceeeeeeeeeeeeeeee
55555555eeeeeeeeeeeeeeeeeeeeeeeee555eeeeee555eeeeeeeeeeee000eeeeee000eee11111111eeeeeeeeeeeeeeeecccccccccccccccceeeeeeeeeeeeeeee
eeeeeee9a9a9aeeeeeeeeee9a9aeaeeeffffff555555ffff88888888888888888888888888888888888888888888888888888888888888888888888888888888
eeeeeee8888899eeeeeeeee88889eeeefffff666666665ff88888888888888888888888888888888888888888888888888888888888888888888888888888888
eeeeee26464629aeeeeeee8888889aeeffff676fff7aa9ff88888888888888888888888888888888888888888888888888888888888888888888888888888888
eeeeee872f378feeeeeeee74488889eefff6765ffff7afff88888888888888888888888888888888888888888888888888888888888888888888888888888888
eeeeee872f3789aeeeeeee3444888eeefff765ffffffffff88888888888888888888888888888888888888888888888888888888888888888888888888888888
eeeeee89ffff8feeeeeeeeff44889aeefff765ffffffffff88888888888888888888888888888888888888888888888888888888888888888888888888888888
eeeeee2ff88989aeeeeeee7f948889eefff765ffffffffff88888888888888888888888888888888888888888888888888888888888888888888888888888888
eeeeeee84ff48eeeeeeeeeff44882eeefff765ffffffffff88888888888888888888888888888888888888888888888888888888888888888888888888888888
eeeeef8888882eee8888888888888888fff765ffffffffffffffffffffffffff88888888888888888888888888888888ffffffffffffffffffffffffffffffff
eeeeef8888882eee8888888888888888fff765fffffffffffff5a999999995ff88888888888888888888888888888888ffffffffffffffffffffffffffffffff
eeeeeeee77768eee8888888888888888fff765ffffffffffff5a999999945fff88888888888888888888888888888888ffffffffffffffffffffffffffffffff
eeeeeeee67688eee8888888888888888fff765fffffffffff54999999945ffff88888888888888888888888888888888ffffffffffffffffffffffffffffffff
eeeee08888888eee8888888888888888fff765ffffffffffff549999999a5fff88888888888888888888888888888888fffffffffffffffffffe82e82e822fff
eeeee08888882eee8888888888888888fff765fffffffffffff54999999995ff88888888888888888888888888888888fffffffffffffffffffe82e82e822fff
eeeeeeeeeeeeeeee8888888888888888fff765fffffffffffffffff65fffffff88888888888888888888888888888888fffffffffffffffffffe82e82e822fff
eeeeeeeeeeeeeeee8888888888888888fff765fffffffffffffffff65fffffff88888888888888888888888888888888fffffffffbbffffffffe82e82e822fff
fffffffffffffffffffffffffffffffffff765fffffffffffffffff65ffffffffffffffffffffffffffffffffffffffffffffb553333bffffff7000670006fff
fffffffffffffffffffffffffffffffffff765fffffffffffffffff65fffffffffffffffffffffffffffffffffffffffffff3333335335fffff7605565066fff
fffffffffffffffffffffffffffffffffff765fffffffffffffffff65ffffffffffffffffffffffffffffffffffffffffffb33333333335ffff7605655066fff
fffffffffffffffffffffffffffffffffff765fffffffffffffffff65ffffffffffffffffffffffffffffffffffffffffff6333b3333b35ffff7655766566fff
fffffffffffffffffffffffffb5ffffffff765fffffffffffffffff65ffffffffffffffffb5ffffffffffffffffffffffff653333333336ffffe82e82e822fff
ffffff765ffffffffb5ffffb3335fffffff765fffffffffffffffbb655fffffffffffffb3333ffffffffffffffffffffffff33333333336ffffb82e82e832fff
fffff66665ffffffb335fff3333b35ffff766655ffffffffffffb3335335fffffffffb3333b35ffffff35fffffbfffffffff3b33335336ffffb333e82e3336ff
ffb3f66b66ffb35f3333ffb33b3333ff6666666655ffffffffff33b333335fffffffb33b333335ffff5533fff35ffffffff553333333355ffb3333333333336f
cccccccccccccccccccccccccccccccccccccccceeeeeeeee2882eeeeeeeeee4449eeeeeeeeeeee28882eeeeeeeeee98e98e9eee000000000000001101100000
cccc110cccccccccccccc10ccccccccccccccccceeeeeeee788782eeeeeeee9aaaa94eeeeeeeee0028200eeeeeeeee9999999eee000000000000005505500000
cccc110cccccccccccccc10ccccccccccccccccceeeeeee7687678eeeeeee9aaa94a94eeeeeeee0440440eeeeeeeee9000009eee000000000000000000000000
cccc110cccccccccccccc10ccccccccccccccccceeeeeee7577878eeeeee0970aa4aa4eeeeeeee073f370eeeeeeeee06c5c60eee000000000000000000000000
cccc110cccccccccccccc10ccccccccccccccccceeeeeee7799678eeeeee5aaaaa49a4eeeeeeee073f370eeeeeeeee07cfc70eee000000000000000000000000
c10c1111cc10ccccc10cc10ccccccccccccccccceeeeeee69ff96feeeeeee9aaaa944eeeeeeeee0fffff0eeeeeeeee0fffff0eee000000000000000000000000
c10c11110c10cc10c10cc10ccccccccccc10cccceeeeeeee69968eeeeeeeee80aa94eeeeeeeeee5077705eeeeeeeeeef999feeee000000000000000000000000
11111111111111111111111110cccccccc10ccc1eeeeeeee69a9eeeeeeeeeee99aaa33eeeeeeeeee555eeeeeeeeeeee9fff4eeee000000000000000000000000
00000000000620000000000000066000000000000000000000aa0aa0aa0aa0aa0a90a900000000000000000000000000000000000000000000000000ee6eeeee
0006880000684200006420000008800068000680006488000a9595595595595595595940000000000000000000000000000000000000000000000000e776eeee
000068800688842006420000000880000680680006422880a9541991991991991a91959400000000000000000000000000000000000000000000000072776eee
6888888408888840688888420208806000888000042006809541111111111111111119590000000000000000000000000000000000000000000000002e7e2eee
688888420808808088888842042886800088400008200640091111111111111111111190000000000000000000000000000000000000000000000000ee7eeeee
000064200008800008420000064888800420420008866420a5a111111111111111111a59000000000000000000000000000000000000000000000000ee2eeeee
000642000004400000842000006444004200042000884200959111111111111111111959000000000000000000000000000000000000000000000000eeeeeeee
000000000002200000000000000620000000000000000000091111111111111111111190000000000000000000000000000000000000000000000000ee6eeeee
000000000006600000000000000620000000000000000000a5a111111111111111111a5a333333333333333333333333333333333333333333333333ee7eeeee
0068200000088000000688000068820000688800680006809591111111111111111119593333333333333333333333333333333333333333333333336e7e6eee
06820000000880000000688006888820068228800680680009111111111111111111119033333333333333333333333333333333333333333333333327767eee
688888820208806068888888088888800820068000888000a5a111111111111111111a5a333333333333333333333333333333333333333333333333e277eeee
888888820828868068888882080880800820068000888000959111111111111111111959333333333333333355555555555555553333333333333333ee2eeeee
088200000688888000006820000880000886682008208200091111111111111111111190333333333333333357777777777777753333333333333333eeeeeeee
008820000068880000068200000880000088820082000820a5a111111111111111111a5a333333333333333357777777777777753333333333333333eeeeeeee
000000000006200000000000000220000000000000000000959111111111111111111959555555555555555557777777777777753333333333333333eeeeeeee
000000000006600000000000000650000000000000000000091111111111111111111190577777777777777557777777777777755555555555555555ee6eeeee
006750000007700000067700006775000067770067000670a5a111111111111111111a5a577777711777777557777771177777755777777117777775e886eeee
06750000000770000000677006777750067557700670670095911111111111111111195957777716617777755777771aa1777775577777199177777582886eee
6777777505077060677777770777777007500670007770000911111111111111111111905777716666177775577771aaaa17777557777199991777752e8e2eee
777777750757767067777775070770700750067000777000a5a111111111111111111a5a5777716665177775577771aaa91777755777719994177775ee8eeeee
077500000677777000006750000770000776675007507500995a1aa1aa1aa1aa1aa1a59457777716517777755777771a917777755777771941777775ee2eeeee
007750000067770000067500000770000077750075000750049595555595595595595940577777711777777557777771177777755777777117777775eeeeeeee
000000000006500000000000000550000000000000000000004404404404404404404400555555555555555555555555555555555555555555555555ee6eeeee
cccccccccccccccccccccccccccccccccccccccccccccccc3535353522666622ee62eeeee68eeeeeee62eeeee67eeeee000000000000000000000000ee8eeeee
c111211cc112211cc112211cc111711cc117711cc117711c5353535335353535e68eeeeeee68eeeee67eeeeeee67eeee0000000000000000000000006e8e6eee
c112211cc121121cc121121cc117711cc171171cc171171c3535353553535353688882e688882eee677772e677772eee00000000000000000000000028868eee
c121211cc111121cc111211cc171711cc111171cc111711c5353535335353535e82eeeeeee82eeeee72eeeeeee72eeee000000000000000000000000e288eeee
c111211cc112211cc111121cc111711cc117711cc111171c3535353553535353ee82eeeee62eeeeeee72eeeee62eeeee000000000000000000000000ee2eeeee
c111211cc121111cc121121cc111711cc171111cc171171c5353535335353535eeeeeeeeeeeeeeeeeeeeeeeeeeeeeeee000000000000000000000000eeeeeeee
c111211cc122221cc112211cc111711cc177771cc117711c3535353553535353eeeeeeeeeeeeeeeeeeeeeeeeeeeeeeee000000000000000000000000eeeeeeee
cccccccccccccccccccccccccccccccccccccccccccccccc8877778835353535eeeeeeeeeeeeeeeeeeeeeeeeeeeeeeee000000000000000000000000eeeeeeee
cccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccceeeeeeeccccceeeeeeeeeeee7776eeeeeeeeeeeccccdeeee
cccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccceeeeeed44444deeeeeeeeee677776eeeeeeeeeccccccdeee
cc99cccccccccccccc99cccccccccccccc99cccccccccccccc99cccccccccccccc99cccccccccccceeeeeec71f17ceeeeeeeeee050011eeeeeeeee744cccceee
cc548ecccce8888ccc54888ecccce88ccc5488888ecccccccc549999cccc999ccc541111cccc111ceeeeeec71f17ceeeeeeeeee500011eeeeeeeee1444ccceee
cc5488e88888888ccc548888e888888ccc54888888e8888ccc5499999999999ccc5411117771111ceeeeeec9ffffceeeeeeeeee677776eeeeeeeeeff44ccceee
cc5488888888888ccc5488888888888ccc54888888e8888ccc5499999999999ccc5411175757111ceeeeeedff889ceeeeeeeeee650056eeeeeeeee7f94ccceee
cc5488888888888ccc5488888888888ccc54888888e8888ccc5499999999999ccc5411175757111ceeeeeeec4ff4ceeeeeeeeeee6666eeeeeeeeeeff44ccdeee
cc5488888888888ccc5488888888888ccc5488888888888ccc5499999999999ccc5411177577111ceeeeeeeed9fdeeeeeeeeeeee52256eeeeeeeeeeffccdeeee
cc5488888888888ccc5488888888888ccc5488888888888ccc5499999999999ccc5411116761111ceeeee9cccccddeeeeeeee05670076eeeeeeeeeee6766eeee
cc5488888888888ccc5488888888888ccc5488888888888ccc5499999999999ccc5411116761111ceeeeefccccccdeeeeeeee06770076eeeeeeeeee677766eee
cc54cc888888cccccc54cccc8888cccccc54ccccc488888ccc54cccc9999cccccc54ccc11111cccceeeeeeee7776ceeeeeeeeeee70076eeeeeeeeee050676eee
cc54cccccccccccccc54cccccccccccccc54cccccccccccccc54cccccccccccccc54cccccccccccceeeeeeee676cceeeeeeeeeee55555eeeeeeeeee500676eee
cc54cccccccccccccc54cccccccccccccc54cccccccccccccc54cccccccccccccc54cccccccccccceeeee0ccccccceeeeeeee00000000eeeeeeeeee677776eee
cc54cccccccccccccc54cccccccccccccc54cccccccccccccc54cccccccccccccc54cccccccccccceeeee0ccccccdeeeeeeee00000000eeeeeeeeee056776eee
cc54cccccccccccccc54cccccccccccccc54cccccccccccccc54cccccccccccccc54cccccccccccceeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeee6666eeee
cc54cccccccccccccc54cccccccccccccc54cccccccccccccc54cccccccccccccc54cccccccccccceeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeee52256eee
cccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccceeeeeeeee1ceeeeeeeeeee4444eeeeeeeeeeeeeee1ceeeee
cccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccceeeeeeeeccc1eeeeeeeee4aa9a4eeeeeeeeeeeeeccc1eeee
cc99cccccccccccccc99cccccccccccccc99cccccccccccccc99cccccccccccccc99cccccccccccceeeeeee1cccc6eeeeeeee908a089eeeeeeeeeee1cccc6eee
cc5488888888eccccc548888eccce88ccc5488ecccce888ccc54eeeecccceeeccc542222cccc222ceeeeee1cc1ccceeeeeee9708a0874eeeeeeeee1cc1ccceee
cc5488888888e88ccc548888e888888ccc54888e8888888ccc54eeeeeeeeeeeccc5422227772222ceeeeee5000001eeeeeee967707764eeeeeeeee0500c00eee
cc5488888888e88ccc548888e888888ccc54888e8888888ccc54eeeeeeeeeeeccc5422275757222ceeeeeee50600eeeeeeeee96777694eeeeeeeee00ffc1eeee
cc5488888888e88ccc5488888888888ccc5488888888888ccc54eeeeeeeeeeeccc5422275757222ceeeeeee77777eeeeeeeeee9aaa94eeeeeeeeeee77fcfeeee
cc5488888888e88ccc5488888888888ccc5488888888888ccc54eeeeeeeeeeeccc5422277577222ceeeeeee67776eeeeeeeeeee99a8a88eeeeeeeee76ff6eeee
cc5488888888888ccc5488888888888ccc5488888888888ccc54eeeeeeeeeeeccc5422226762222ceeeeefc8888aeeeeeeeee9a78aa8888eeeeeeee4449eeeee
cc5488888888888ccc5488888888888ccc5488888888888ccc54eeeeeeeeeeeccc5422226762222ceeeeefc88a88eeeeeeeee9a7a999088eeeeeee9aaaa94eee
cc54cccccccc488ccc54ccccc4888ccccc54cccc48888ccccc54cccceeeecccccc54ccc22222cccceeeeeeef888aeeeeeeeeeeee99880888eeeee988a94a94ee
cc54cccccccccccccc54cccccccccccccc54cccccccccccccc54cccccccccccccc54cccccccccccceeeeeeefa888eeeeeeeeeeeea8aaa088eeee0900a64aa4ee
cc54cccccccccccccc54cccccccccccccc54cccccccccccccc54cccccccccccccc54cccccccccccceeeeefc1111aeeeeeeeeea8a8a8a888eeeee5aa77749a4ee
cc54cccccccccccccc54cccccccccccccc54cccccccccccccc54cccccccccccccc54cccccccccccceeeeecf11118eeeeeeeee8aaa8aa8eeeeeeee77776944eee
cc54cccccccccccccc54cccccccccccccc54cccccccccccccc54cccccccccccccc54cccccccccccceeeeeeeeeeeeeeeeeeeeee9999eeeeeeeeeeee776a94eeee
cc54cccccccccccccc54cccccccccccccc54cccccccccccccc54cccccccccccccc54cccccccccccceeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeee99aaa33ee
__label__
33333333333333333333333333333333333333333333333333333333333333333333333333333333333333333333333333333333333333333333333333333333
33333333333333333333333333333333333333333333333333333333333333333333333333333333333333333333333333333333333333333333333333333333
33333333333333333353333333333333333333333333333333333333333333333333333333333333333333333333333333333333333333333333333333333333
33333333333333333333333333333333333333333333333333333333333333333333333333333333333b33333333333333333333333333333333333333333333
33333333333333333333333333333333333333333333333333333333333333333333333333333333333333333333333333333333333333333333333333333333
33333333333333333333333333333333333535333333333333333333333333333333333333333333333333333333333333333333333333333335353333333333
33333333333333333333333333333333333333333333333333333333333333333333333333333333333333333333333333333333333333333333333333333333
33333333333333333333333333333333333333333333333333333333333333333333333333333333333333333333333333333333333333333333333333333333
33333333333333333333333333333333333333333333333333333333333333333333333333333333333333333333333333333333333333333333333333333333
33333333333333333333333333333333333333333333333333333333333333333333333333333333333333333333333333333333333333333333333333333333
33333333333333333333333333333333333333333333333333533333333333333333333333333333333333333333333333333333333333333333333333333333
33333333333333333333333333333333333333333333333333333333333333333333333333333333333333333333333333333333333333333333333333333333
33333333333333333333333333333333333333333333333333333333333333333333333333333333333333333333333333333333333333333333333333333333
33333333333333333333333333333333333333333333333333333333333333333333333333353533333333333333333333333333333333333333333333333333
33333333333333333333333333333333333333333333333333333333333333333333333333333333333333333333333333333333333333333333333333333333
33333333333333333333333333333333333333333333333333333333333333333333333333333333333333333333333333333333333333333333333333333333
33333333333333333333333333333333333333333333333333333333333333333333333333333333333333333333333333333333333333333333333333333333
33333333333333333333333333333333333333333333333333333333333333333333333333333333333333333333333333333333333333333333333333333333
33333333333333333333333333333333333333333333333333333333333333333333444433333333333333333333333333333333333333333333333333333333
33333333333333333333333333333333333333333333333333333333333333333334aa9a43333333333333333333333333333333333333333333333333333333
3333333333333333333333333333333333333333333333333333333333333333333908a089333333333333333333333333333333333333333333333333333333
3333333333333333333333333333333333333333333333333333333333333333339708a087433333333333333333333333333333333333333333333333333333
33333333333333333333333333333333333333333333333333333333333333333396770776433333333333333333333333333333333333333333333333333333
887777e8887777e8887777e8887777e8887777e8887777e8887777e8887777e888796777694777e8887777e8887777e8887777e8887777e8887777e8887777e8
555555555555555555555555555555555555555555555555555555555555555555559aaa94555555555555555555555555555555555555555555555555555555
55555555555555555555555555555555555555555555555555555555555555555555599a8a885555555555555555555555555555555555555555555555555555
55555555555555555555555555555555555555555555555555555555555555555559a78aa8888555555555555555555555555555555555555555555555555555
55555555555555555555555555555555555555555555555555555555555555555809a7a999888555555555555555555555555555555555555555555555555555
55555555555555555555555555555555555555555555555555555555555555558805559988888855555555555555555555555555555555555555555555555555
5555555555555555555556555555555555555555555555555555555555555558820555a8a4902855555555555555555555555555555555555555555555555555
5555555555555555555555555555555555555555555555555555555555555588825a8a8a48825555555555555555555555555555555555555555555555555555
55555555555555555555555555555555555555555555555555555555555558888882222288825555555555555555555555555555555555555555555555555555
55765576557655765576557655765576557655765576557655665566557688855088888800025576557655765576557655765576556655665576557655765576
55555555555555555555555555555555555555555555555555555555555988557008888007005555555555555555555555555555555555555555555555555555
55555555555555555555555555555555555555555555555555555555556988576508888076555555555555555555555555555555555555555555555555555555
55555555555555555555555555555555555555555555555555555555552222505002222005055555555555555555555555555555555555555555555555555555
55555555555555555555555555555555555555555555555555555555555555500055555500555555555555555555555555555555555555555555555555555555
55555555555555555555555555555555555555555555555555655555555555555555555555555555555555555555555555555555556555555555555555555555
55555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555
55555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555
22766682227666822276668222766682227666822276668222766682227666822276668222766682227666822276668222766682227666822276668222766682
33333333333333333333333333333333333333333333333333333333333333333333333333333333333333333333333333333333333333333333333333333333
33333333333333333333333333333333333333333333333333333333333333333333333333333333333333333333333333333333333333333333333333333333
33333333333333333330033333300333330003333300033333000333333003333333333333000333330003333330033333000333330003333333333333333333
33333333333333333307703333077033307770333077703330777033330770333333333330777033307770333307703330777033307770333333333333333333
33333333333333333070033330707033307770333070703330707033307003333333333330707033307070333070033330700333307070333333333333333333
33333333333333333070333330707033307070333077703330777033307770333333333330770333307770333070333330770333307703333333333333333333
33333333333333333070033330707033307070333070033330707033330070333333333330707033307070333070033330700333307070333333333333333333
33333333333333333307703330770333307070333070333330707033307703333333333330707033307070333307703330777033307070333333333333333333
33333333333333333330033333003333330303333303333333030333330033333333333333030333330303333330033333000333330303333333333333333333
33333333333333333333333333333333333333333333333333333333333333333333333333333333333333333353333333333333333333333333333333333333
33333333333333333333337773377377733333377373737773777377737773333373733333777373737773377337733773377377733333333333333333333333
33333333333333333333337373737373733333733373733733733373737373333373733333373373737333733373737373733373333333333333333333333333
33333333333333333335357773737377333333777373733733773377337773333377733333373377737733733373737373777377333535333333333333333333
33333333333333333333337333737373733333337373733733733373737333333333733333373373737333737373737373337373333333333333333333333333
33333333333333333333337333773373733333773337733733777373737333333377733333373373737773777377337733773377733333333333333333333333
33333333333333333333333333333333333333333333333333333333333333333333333333333333333333333333333333333333333333333333333333333333
33333333333333333333333333333333333333333333333333333333333333333333333333333333333333333333333333333333333333333333333333333333
333333aaa3a3a3a3333aa3aaa33333a3a3aa333333aaa33aa3aaa33aa3aa333333aaa3aaa3aaa3aaa333333aa33aa3aa33aaa3aaa3aa33a3a3aaa3aaa3333333
333333a3a3a3a3a333a333a3a33b33a3a3a3a33333a3a3a3a33a33a3a3a3a33333a3a3a3a3a3a3a3a33333a333a3a3a3a33a333a33a3a3a3a3a3a3a3a3333333
333333aaa3a3a3a333aaa3aaa33333a3a3a3a33333aa33a3a33a33a3a3a3a33333aaa3aaa3aa33aaa33333a333a3a3a3a33a333a33a3a3a3a3aaa3aa33333333
333333a333a3a3a33333a3a3a33333a3a3a3a33333a3a3a3a33a33a3a3a3a33333a535a3a3a3a3a3a33333a333a3a3a3a33a333a33a3a3a3a3a3a3a3a3333333
333333a3333aa3aaa3aa33a3a333333aa3a3a33333aaa3aa333a33aa33a3a33333a333a3a3a3a3a3a333333aa3aa33a3a33a33aaa3a3a33aa3a3a3a3a3333333
33333333333333333333333333333333333333333333333333333333333333333333333333333333333333333333333333333333333333333333333333333333
33333333333333333333333333333333333333333333333333333333333333333333333333333333333333333333333333333333333333333333333333333333
33333333333333333333333333333333333333333333333333333333333333333333333333333333333333333333333333333333333333333333333333333333
33333333333333333333333333333333333333333333333333333333333333333333333333333333333333333333333333333333333333333333333333333333
33333333333333333333333333333333333333333333333333333333333333333333333333333333333333333333333333333333333333333333333333333333
33333333333333333333333333333333333333333333333333333333333333333333333333333333333333333333333333333333333333333333333333333333
33333333333333333333333333333333333333333333333333333333333333333333333333333333333333333333333333333333333333333333333333333333
33333333333333333333333333333333333333333333333333333333333333333333333333333333333333333333333333333333333333333333333333333333
887777e8887777e8887777e8887777e8887777e8887777e8887777e8887777e8887777e8887777e8887777e8887777e8887777e8887777e8887777e8887777e8
55555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555
55555555555555555555555555555555555555555555555555552225225552252555222552255555555555555555555555555555555555555555555555555555
55555555555555555555555555555555555555555555555555555255252525552555255525555555555555555555555555555555555555555555555555555555
55555555555555555555555555555555555555555555555555555255252525552555225522255555555555555555555555555555555555555555555555555555
55555555555555555555555555555555555555555555555555555255252525252555255555255555555555555555555555555555555555555555555555555555
55555555555555555555555555555555555555555555565555552225252522252225222522555555555555555555555555555555555556555555555555555555
55555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555
55555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555
55765576556655665576557655765576557655765576557655765576557655765576557655765576557655765576557655765576557655765566556655765576
55555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555
55555555555555555555555555555555555555558555588588855885888588858555855588858855588555855555555555555555555555555555555555555555
55555555555555555555555555555555555555555855855585858555585585558555855585858585858558555555555555555555555555555555555555555555
55555555555555555555555555555555555555555585855588858885585588558555855588858585858585555555555555555555555555555555555555555555
55555555556555555555555555555555555555555855855585855585585585558555855585858585858558555555555555555555555555555565555555555555
55555555555555555555555555555555555555558555588585858855585588858885888585858585885555855555555555555555555555555555555555555555
55555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555
22766682227666822276668222766682227666822276668222766682227666822276668222766682227666822276668222766682227666822276668222766682
33333333333333333333333333333333333333333333333333333333333333333333333333333333333333333333333333333333333333333333333333333333
33333333333333333333333333333333333333333333333333333333333333333333333333333333333333333333333333333333333333333333333333333333
33333333333333333333333333333333333333333333333333333333333333333333333333333333333333333333333333333333333333333333333333333333
33333333333333333333333333333333333333333333333333333333333333333333333333333333333333333333333333333333333333333333333333333333
33333333333333333333333333333333333333333333333333333333333333333333333333333333333333333333333333333333333333333333333333333333
33333333333333333333333333333333333333333333333333333333333333333333333333333333333333333333333333333333333333333333333333333333
33333333333333333333333333333333333333333333333333333333333333333333333333333333333333333333333333333333333333333333333333333333
33333333333333333333333333333333333333333333333333333333333333333333333333333333333333333333333333333333333333333333333333333333
33333333333333333333333333333333333333333333333333333333333333333333333333333333333333333333333333333333333333333333333333333333
33333333333333333353333333333333333333333333333333333333335333333333333333333333333333333333333333333333333333333333333333333333
33333333333333333333333333333333333333333333333333333333333333333333333333333333333b33333333333333333333333333333333333333333333
33333333333333333333333333333333333333333333333333333333333333333333333333333333333333333333333333333333333333333333333333333333
33333333333333333333333333333333333535333333333333333333333333333333333333333333333333333333333333333333333333333335353333333333
33333333333333333333333333333333333333333333333333333333333333333333333333333333333333333333333333333333333333333333333333333333
33333333333333333333333333333333333333333333333333333333333333333333333333333333333333333333333333333333333333333333333333333333
cc66cc66cc66cc66cc66cc66cc66cc66cc66cc66cc66cc66cc66cc66cc66cc66cc66cc66cc66cc66cc66cc66cc66cc66cc66cc66cc66cc66cc66cc66cc66cc66
11cc11cc11cc11cc11cc11cc11cc11cc11cc11cc11cc11cc11cc11cc11cc11cc11cc11cc11cc11cc11cc11cc11cc11cc11cc11cc11cc11cc11cc11cc11cc11cc
cc11cc11cc11cc11cc11cc11cc11cc11cc11cc11cc11cc11cc11cc11cc11cc11cc11cc11cc11cc11cc11cc11cc11cc11cc11cc11cc11cc11cc11cc11cc11cc11
11111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111
11111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111
11111111111111111111111111111111111111111111111111110001000110010111000110011111111111111111111111111111111111111111111111111111
11111111111111111111111111111111111111111111111111107770777007707010777007701111111111111111111111111111111111111111111111111111
11111111111111111111111111111111111111111111111111110700700070007010707070011111111111111111111111111111111111111111111111111111
11111111111111111111111111111111111111111111111111110700770070107010777077701111111111111111111111111111111111111111111111111111
11111111111111111111111111111111111111111111111111110700700070007000707000701111111111111111111111111111111111111111111111111111
11111111111111111111111111111111111111111111111111110700777007707770707077011111111111111111111111111111111111111111111111111111
11111111111111111111111111111111111111111111111111111011000110010001010100111111111111111111111111111111111111111111111111111111
11111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111
11111111111111111111111111111621111111166111111001010100011001100100010001100111111111111111111111000111111111111101011111111111
11111111682111111116881111116882111111188111110770707077700770077077707770077011111111111116888110777011116811168070701111111111
11111116821111111111688111168888211111188111107000707070707000707070707000700111111111111168228811007011111681681070701111111111
11111168888882116888888811188888811112188161107010707077007770707077007700777011111111111182116811070111111188811107011111111111
11111188888882116888888211181881811118288681107000707070700070707070707001007011111111111182116810700111111188811070701111111111
11111118821111111111682111111881111116888881110770077070707700770070707770770111111111111188668210777011111821821070701111111111
11111111882111111116821111111881111111688811111001100101010011001101010001001111111111111118882111000111118211182101011111111111
11111111111111111111111111111221111111162111111111111111111111111111111111111111111111111111111111111111111111111111111111111111
11111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111
11111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111
11111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111

__map__
0909090909090909092c09090c0d0909000000000000000000000000000000000000000000000000000000000000000019191b191f19191919190b1919191f190909090909090909092c09090c0d0909000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0909092d09c0c109090909091c1d092d00868787878787878787878787878800000000000000000000000000000000001919191919191b19191f1919191919190909092d09090909090909091c1d092d000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
3c3d707173d0d1093c2d72737470710900969797979797979797979797979800000000000000000000000000000000001e1e1e1e1e1e1e1e1e1e1e1e1e1e1e1e3c3d0909093c2d090909090909090909000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
b6b6b6b6b6b6b6b6b6b6b6b6b6b6b6b600969797979797979797979797979800000000000000000000000000000000000a0a200a0a0a0a0a0a200a0a0a0a0a0a19191919191919191919191919191919000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0a0a0a0a0a0a0a0a0a0a0a0a0a0a0a0a00969797979797979797979797979800868787878787878787878787878787881a1a1a1a1a1a301a1a1a1a1a1a301a1a19191919191919191919191919191919000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
1a1a1a1a1a1a1a1a1a1a1a1a1a1a1a1a00969797979797979797979797979800969797979797979797979797979797980f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f19191919191919191919191919191919000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
10101010101010101010101010101010009697979797979797979797979798009697979797979797979797979797979819191f191919191919190b1b191f191919191919191919191919191919191919000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0a0a0a0a0a0a0a0a0a0a0a0a0a0a0a0a00969797979797979797979797979800969797979797979797979797979797981919190b191919191f1919191919191919191919191919191919191919191919000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
1a1a1a1a1a1a1a1a1a1a1a1a1a1a1a1a00969797979797979797979797979800969797979797979797979797979797981e1e1e1e1e1e1e1e1e1e1e1e1e1e1e1e1919191919999a9b9c19191919191919000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
1010101010101010101010101010101000969797979797979797979797979800969797979797979797979797979797980a0a0a0a0a200a0a0a0a0a0a0a200a0a1919191919a9aaabacadae1919191919000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0a0a0a0a0a0a0a0a0a0a0a0a0a0a0a0a00969797979797979797979797979800a6a7a7a7a7a7a7a7a7a7a7a7a7a7a7a81a301a1a1a1a1a1a1a1a1a1a1a1a301a19191919191919191919191919191919000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
1a1a1a1a1a1a1a1a1a1a1a1a1a1a1a1a00a6a7a7a7a7a7a7a7a7a7a7a7a7a800000000000000000000000000000000000f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f19191919191919191919191919191919000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
b7b7b7b7b7b7b7b7b7b7b7b7b7b7b7b7000000000000000000000000000000000000000000000000000000000000000019191b191f19191b19190b1919191f1919191919191919191919191919191919000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
3939393939393939393939393939393939393939393939393939393939393939393939393939393939393939393939393939393939393939393939393939393939393939393939393939393939393939000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
2929292929292929292929292929292929292929292929292929292929292929292929292929292929292929292929292929292929292929292929292929292929292929292929292929292929292929000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
2929292929292929292929292929292929292929292929292929292929292929292929292929292929292929292929292929292929292929292929292929292929292929292929292929292929292929000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
__sfx__
000600001e020340203a0202c000000000c0000500000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00100000271501a1501a1500000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
011900001874025000260002600026000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
011900002b7702b7702b7702600000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
010c00000000000000000000000000000000000000000000000000000000000000000000000000000000000018525000001a535000001c535000001d5350000020535000001d535000001c535000002053500000
011600000c515105150c515105150c515105150c515105150e515115150e515115150e515115150e5151151510515145151051514515105151451510515145150e515115150e515115150e515115150e51511515
010600001e150000001e150001002a150000000c00005000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0106000024455004002645500400284550040029455004002c45500400294550040028455004002c4550040024455004000040000400004000040000000000000000000000000000000000000000000000000000
0106000028455000002c4550000029455000002845500000264550000028455000002c45500000294550000024455000000000000000000000000000000000000000000000000000000000000000000000000000
010600000c0230000000000000000c023000000c02300605246550000000000000000c023000000c023246050c0530000000000000000c023000000c02324605246550000000000000000c023000000c02300000
0106000028455000002c455000002945500000264552645528455284002c455000002945500000284552845528455000002c455000052945500000264552645528455000002c4550000029455000002845528455
0106000028455284022c4552c4022945529402264552640226455284122c4552c412294552941228455284122e4552e4122b4552b412294552941228455284122645526412294552941226455264122945529412
010600002444018400000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
01080000000000c05300000000002465500000000000c05300000000002465500000000000c05300000000002465500000000000c05300000000002465500000000000c05300000000002465500000000000c053
011000001852218512000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000100000000000000000
001000000c2120c2120c21400000132140000013214000000c2140c2120c2120c2120000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
011600000c115101150c115101150c115101150c115101150e115111150e115111150e115111150e1151111510115141151011514115101151411510115141150e115111150e115111150e115111150e11511115
011900001834018340183401834000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
010600001c140000001c1400000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
010c00000c15400100001000010010154001001315400100181541814018130181201315013140131301312010154001000010000100131540010018154001001d1541d1401d1301d12018150181401813018120
010c0000181540010000100001001c154001001f15400100241342413224132241322413224132241322413224122241222412224122241122411224112241122411200100001000010000100001000000000000
010601200c6050c6050c60500000000000000000000000000c6050c6050c60500000000000000000000000000c6150c6150c6550c6550c6050c6050c6050c6050c6050c6050c6050c60500000000000000000000
0106000000000000000000000000000000000000000000000c6150c6150c6150c6150c6250c6250c6250c6250c6350c6350c6350c6350c6550c6550c6550c6550c6650c6650c6650c6650c6750c6750c6750c675
010c00000c75400700007000070010754007001375400700187541874018730187201375013740137301372010754007000070000700137540070018754007001d7541d7401d7301d72018750187401873018720
010c0000187540070000700007001c754007001f75400700247342473224732247322473224732247322473224722247222472224722247122471224712247122471200000000000000000000000000000000000
010600000c6250c6250c6250c6250c6150c6150c6150c6150c6550000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
010500000c5700e5701057011570135701557017570185701a5701c5701d5701f5702157023570245700050000500005000050000500000000000000000000000000000000000000000000000000000000000000
010500002457023570215701f5701d5701c5701a5701857017570155701357011570105700e5700c5700050000500005000050000500000000000000000000000000000000000000000000000000000000000000
010600002b470000002b4700000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
010600000047000000004700000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
010700002465500000000000c05300000000002465500000000000c05300000000002465500000000000c05300000000002465500000000000c05300000000002465500000000000c05300000000002465500000
01070000000000c05300000000002465500000000000c05300000000002465500000000000c05300000000002465500000000000c05300000000002465500000000000c05300000000002465500000000000c053
011000001a750000001a730000001a730000001a730000001c750000001c730000001c730000001c730000001d750000001d750000001d750000001d750000001f770000001f770000001f770000001f77000000
01100000000001a750000001a730000001a730000001a730000001c750000001c730000001c730000001c730000001d750000001d750000001d750000001d750000001f770000001f770000001f770000001f770
001000002461524615246152461524615246152461524615246152461524615246152461524615246152461524625246252462524625246252462524625246252462524625246252462524635246352463524635
01100000210551f055210551d055210552405522055210551f0551d0551c0551d0551d0551c0551d0551a0551d055210551f0551d0551c0551a0551c0551d0551d0551c0551d055180551d055210551f0551d055
011000001c0551a055180551605516055180551a0551c0551d0551f055210551f0551d0551d0551d0451d0351d0251d0151d0151d015000000000000000000000000000000000000000000000000000000000000
0110000024615186150c615246450c6150c615246150c6150c615246350c6150c615246150c6150c615246450c6150c615246150c6150c615246350c6150c615246150c6150c615246450c6150c615246150c615
010700001a750000000000000000000000000000000005001a730000000000000000000000000000000000001a750000000000000000000000000000000000001a73000000000000000000000000000000000000
011000000c615246450c6150c615246150c6150c615246350c6150c615246150c6150c615246450c6150c615246150c6150c61524615000000000000000000000000000000000000000000000246250000024655
011000001555015530155101155011530114101655016530135101155011530115101155011530115100e5500e5300e4101355013530135100e5500e5300e5101155011530115100c5500c5300c4101355013530
01100000135100e5500e5300e5100e5500c5300c5100c550115401151011550110401103011020110101101011010110101101011010110101101011010110150000000000000000000000000000000000000000
0107000012430124352243500400004002243022430224302243022430224352343023430234351e4301e4301e435224302243022435204302043020435004000d4300d435204350040000400204302043020430
010700000143001430014350d4300d4300d4350143001430014350d4300d4300d4350343003430034350f4301e4301e4300343003430034350f4300f4300f4350343003430034350f4300f4300f4350343003430
010700002043020430204352243022430224351d4301d4301d4352043020430204351e4301e4301e435004000f4300f4351e43500400004001e4301e4301e4301e4301e4301e4351e4301e4301e4351943019430
01070000034350f4300f4300f4350043000430004350b4301e4301e43000430004300b4301e4301e4301e4300043000430004350b4300b4300b4350043000430004350b4300b4300b43506430064300643512430
01070000194352043020430204351e4301e4301e435004000b4300b4351e43500400004350b4300b435004001e4301e4301e4351d4301d4301d4351e4301e4301e43520430204302043522430224302243500400
010700002043020430204352543025430254351d4301d4301d4352043020430204351e4301e4301e435004000f4300f4351e43500400004001e4301e4301e4350040000400004001e4301e4301e4351943019430
01070000034350f4300f4300f4350043000430004350b4301e4301e4300043000430004350b4300b4300b4350043000430004350b4300b4300b4350043000430004350b4300b4300b43506430064300643512430
01070000194352043020430204351e4301e4301e435004000b4300b4351e43500400004001e4301e4301e4301e4301e4301e4351d4301d4301d4351e4301e4301e4352043020430204351e4301e4301e4351e430
010700001243012435064300643006435124301243012435064300643006435124301243012435064300643006435124301243012435064300643006435124301243012435064300643006435124301243012435
010700001e4301e4351e4301e4301e4351e4301e4301e4351e4301e4301e4301e4301e4301e4351e4301e4301e4351e4301e4301e435204302043020435224302243022430224302243022435224302243022430
010700000643006430064351243012430124350643006430064351243012430124350643006430064351243012430124350643006430064351243012430124350643006430064351243012430124350643006430
010700002243022430224302243022430224302243022430224302243022430224352543025430254302543025430254351e4301e4301e4351e4301e4301e4351e4301e4301e4301e4301e4301e4351e4301e430
01070000064351243012430124350643006430064351243012430124350643006430064351243012430124350643006430064351243012430124350643006430064351243012430124350143001430014350d430
010700001e4351e4301e4301e4352243022430224352043020430204302043020430204351e4301e4301e4301e4301e4301e4301e4301e4301e4301e4301e4301e4301e4301e4301e4351d4301d4301d4301d430
010700000d4300d4350143001430014350d4300d4300d4350143001430014350d4300d4300d4350143001430014350d4300d4300d4350143001430014350d4300d4300d4350143001430014350d4300d4300d435
010700001d4301d4351b4301b4301b435194301943019430194301943019430194301943019430194301943019430194301943019430194301943019430194301943019435194301943019435194301943019430
010700000143001430014350d4300d4300d4350143001430014350d4300d4300d4350643006430064351243012430124350643006430064351243012430124350643006430064351243012430124350643006430
000700001943019430194351943019430194351b4301b4301b4351d4301d4301d4351e4301e4301e4301e4301e4301e4351b4301b4301b4351943019430194301943019430194301943019430194301943019430
010700000643512430124301243506430064300643512430124301243506430064300643512430124301243506430064300643512430124301243506430064300643512430124301243506430064300643512430
01070000194301943019430194352a4302a4302a4302a4302a4302a4352743027430274352543025430254302543025430254302543025430254302543025430254351943019430194351e4301e4301e4351e430
0107000022430224300643006430064351243012430124350643006430064351243012430124350643006430064351243012430124350143001430014350d43020430204300143001430014350d4300d4300d435
0107000000000000002465500000000000c05300000000002465500000000000c05300000000002465500000000000c05300000000002465500000000000c05300000000002465500000000000c0530000000000
__music__
04 040d4344
03 05424344
01 060c0944
00 06070944
00 06470944
00 06080944
00 06470944
00 06070944
00 064c0944
00 060a0944
02 060b0944
03 05104344
01 13151744
05 14161844
00 26266244
00 20212260
01 2325286a
02 2427296a
01 3e2a3f44
00 2b2c1e44
00 2d2e1f44
00 3e2a3f44
00 2b2f1e44
00 30311f44
00 32333f44
00 34351e44
00 36371f44
00 38393f44
00 3a3b1e44
02 3c3d1f44
00 41424344
00 41424344
00 41424344
00 41424344
00 41424344
00 41424344
00 41424344
00 41424344
00 41424344
00 51424344
01 040d4344
04 0e0f4344

