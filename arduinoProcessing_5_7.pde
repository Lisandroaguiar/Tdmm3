import processing.sound.*;
import processing.serial.*;

Serial myPort;  // Create object from Serial class
AudioIn microfono;
Amplitude amp;
Amplitude volumenSonido;
Amplitude volumenMaquina1;
Amplitude volumenMaquina2;
Amplitude volumenMaquina3;
Amplitude volumenMaquina4;
Amplitude volumenMaquinaZapateo1;
Amplitude volumenMaquinaZapateo2;
Amplitude volumenMaquinaZapateo3;
Amplitude volumenRisa;
int numDeImagen;
PImage muerte[];
String val;
String estado="inicio";
int vidaMaquina=500;
float pisoAmp=0.25;
float a=0;
float moverPerdiste=0;
int estadoZapateo=0;
int contadorTitilar;
int queSonido=1;
int marcaDeTiempoMaquina;
int tiempoFinalMaquina=5000; // TIEMPO DEL TURNO DE LA MAQUINA 1 segundo=1000
int tiempoMaquina;
int marcaDeTiempoJugador;
int tiempoFinalJugador=10000; // TIEMPO DE ZAPATEO DEL TURNO DEL JUGADOR 1 segundo=1000
int tiempoJugador;
int marcaDeTiempoGanaste;
int tiempoFinalGanaste=40000; // TIEMPO PARA CAMBIAR LA RESISTENCIA 1 segundo=1000 (tiempo? quizas mejor boton de reiniciar, veremos)
int tiempoGanaste;
int marcaDeTiempoJuego;
int tiempoJuegoFinal=10000000; //TIEMPO DE INACTIVIDAD EN EL INICIO  1 segundo=1000
int tiempoJuego;
int marcaDeTiempoPerder;
int tiempoFinalPerder=60000; //TIEMPO PARA GANARLE A LA MAQUINA  1 segundo=1000
int tiempoPerder;
int marcaDeTiempoReiniciar;
int tiempoFinalReiniciar=15000; //TIEMPO QUE TARDA EN REINICIAR DESPUES DE PERDER  1 segundo=1000
int tiempoReiniciar;
int marcaDeTiempoSonido;
int tiempoFinalSonido=17000; //TIEMPO QUE TARDA EN REINICIAR DESPUES DE PERDER  1 segundo=1000
int tiempoSonido;
int marcaDeTiempoDelay;
int tiempoFinalDelay=17000; //TIEMPO QUE TARDA EN CERRAR DESPUES DE PERDER  1 segundo=1000
int tiempoDelay;
int tdeJugador=10000;
int empezo, tiempoDeZapateo;
boolean empezoElJuego=false;
boolean sonar=false;
boolean girarServo;
boolean yaEligio;
SoundFile[] sonido;
SoundFile[] resp;
SoundFile base, risa, maquinaMuere;
PImage risas;
boolean zapatear=true, respuestaM=false, setear=true;
int estados=0;
int[] tdeMaquina = { 8000, 13000, 17000 };
int empezarJuego, marcaDeTiempoInicio;
void setup()
{
  size(1440, 900);
  //fullScreen();
  amp = new Amplitude(this);
  volumenSonido= new Amplitude(this);

  volumenMaquina1=new Amplitude  (this);
  volumenMaquina2=new Amplitude  (this);
  volumenMaquina3=new Amplitude  (this);
  volumenMaquina4=new Amplitude  (this);
  volumenMaquinaZapateo1=new Amplitude  (this);
  volumenMaquinaZapateo2=new Amplitude  (this);
  volumenMaquinaZapateo3=new Amplitude  (this);
  volumenRisa=new Amplitude (this);
  microfono = new AudioIn(this, 0);
  muerte=new PImage[99];
  microfono.start();
  amp.input(microfono);
  String portName = Serial.list()[0];
  myPort = new Serial(this, portName, 9600);
  sonido= new SoundFile[4];
  for (int i=0; i<sonido.length; i++) {

    sonido[i]=new SoundFile(this, "audio"+i+".wav");
    sonido[i].amp(0.2);
  }

  sonido[0].play();
  resp= new SoundFile[3];
  for (int i=0; i<resp.length; i++) {

    resp[i]=new SoundFile(this, "resp"+i+".wav");
    resp[i].amp(0.2);
  }
  for (int i=0; i<muerte.length; i++) {

    muerte[i]=loadImage("imagenes/img("+i+").jpg");
  }
  base= new SoundFile(this, "base.wav");
  risa= new SoundFile(this, "risa.wav");
  maquinaMuere= new SoundFile(this, "maquinaMuere.wav");

  risa.amp(0.5);
  risas= loadImage("risaM.jpg");
  volumenMaquina1.input(sonido[0]);
  volumenMaquina2.input(sonido[1]);
  volumenMaquina3.input(sonido[2]);
  volumenMaquina4.input(sonido[3]);
  volumenMaquinaZapateo1.input(resp[0]);
  volumenMaquinaZapateo2.input(resp[1]);
  volumenMaquinaZapateo3.input(resp[2]);
  volumenRisa.input(risa);
}

void draw() {
  fill(0);
  rect(0, 0, width, height);
  println(estado, tiempoPerder);
  //println(estado, contadorMaquina, contador, vidaMaquina, segundoJuego);
  //println(amp.analyze());
  if (amp.analyze()>0.3 && estado=="inicio") {
    estado="jugador";
    marcaDeTiempoJugador=millis();
    empezoElJuego=true;
    marcaDeTiempoPerder=millis();
    yaEligio=false;
    myPort.write('5');
  }
  if (yaEligio) {
    myPort.write('9');
  }
  if (estado=="inicio") {
    risa.stop();
    background(0);

    empezarJuego=millis()-marcaDeTiempoInicio;
    girarServo=true;
    tiempoSonido=millis()-marcaDeTiempoSonido;


    vidaMaquina=600;
    tiempoGanaste=0;
    tiempoPerder=0;
    marcaDeTiempoGanaste=millis();
    tiempoJuego=millis()-marcaDeTiempoJuego;


    tiempoReiniciar=0;
    //-----------------cuestion sonido-------------//
    if (tiempoSonido>tiempoFinalSonido) {


      sonido[queSonido].play();

      queSonido++;
      marcaDeTiempoSonido=millis();
    }



    if (queSonido>3) {
      queSonido=1;
      myPort.write('9');
      yaEligio=true;
    }
    a=volumenMaquina4.analyze()*100;
    if (queSonido==1) {
      a=volumenMaquina1.analyze()*100;
    }
    if (queSonido==2) {
      a=volumenMaquina2.analyze()*100;
    }
    if (queSonido==3) {
      a=volumenMaquina3.analyze()*100;
    }


    push();
    noFill();
    strokeWeight(10);
    stroke(255, 0, 0);
    bezier(100.0, 540.0, 490.0, 266.0+a*100, 790.0, 847.0-a*100, 1320.0, 540.0);

    pop();
    println(a, volumenMaquina1.analyze(), queSonido);
  }




  if (empezoElJuego) {
    tiempoPerder=millis()-marcaDeTiempoPerder;
  }
  if (estado=="jugador")
  {
    for (int i=0; i< sonido.length; i++) {
      sonido[i].stop();
    }
    marcaDeTiempoGanaste=millis();
    tiempoGanaste=0;
    marcaDeTiempoMaquina=millis();
    tiempoMaquina=0;
    tiempoJugador=millis()-marcaDeTiempoJugador;
    jugar();
  }




  if (estado=="ganaste") {
    println(tiempoGanaste, numDeImagen);
    tiempoGanaste=millis()-marcaDeTiempoGanaste;
    numDeImagen++;
    if (numDeImagen>98) {
      numDeImagen=0;
    }
    image(muerte[numDeImagen], 0, 0);
    image(muerte[numDeImagen], 0, height/2);
    image(muerte[numDeImagen], width/2, height/2);

    image(muerte[numDeImagen], width/2, 0);
  }
  if (keyPressed==true && key==' ') {

    estado="inicio";
    estados=0;
    zapatear=true;
    respuestaM=false;
    setear=true;
  }
  if (key=='c') {
    myPort.write('8');
  }
  if (estado=="perdiste") {


    push();
    fill(255, 0, 0);
    moverPerdiste=volumenRisa.analyze();
    rect(width/2-700, height/5-100+moverPerdiste*50, 200, 400-moverPerdiste*300);
    rect(width/2+500, height/5-100+moverPerdiste*50, 200, 400-moverPerdiste*300);
    noFill();
    strokeWeight(10);
    stroke(255, 0, 0);
    bezier(200.0,562.0-moverPerdiste*100,491.0,562.0+moverPerdiste*1000,1015.0,562.0+moverPerdiste*1000,1200.0,562.0-moverPerdiste*100);


    pop();
    tiempoJuego=0;
    empezoElJuego=false;
    println(tiempoReiniciar);
    marcaDeTiempoPerder=millis();
    tiempoReiniciar=millis()-marcaDeTiempoReiniciar;
    tiempoPerder=0;
    contadorTitilar++;
    if (contadorTitilar%15==0) {
      myPort.write('0');
    } else {
      myPort.write("3");
    }

    if (tiempoReiniciar>tiempoFinalReiniciar) {
      marcaDeTiempoInicio=millis();
      contadorTitilar=0;
      queSonido=0;
      risa.stop();
      zapatear=true;
      respuestaM=false;
      setear=true;
      estados=0;
   //   myPort.write('3');
      estado="inicio";
    }
  }
}

void zapatear() {
  if ( setear==true) {
    empezo=millis();
    setear=false;
    base.play();
  }
  tiempoDeZapateo=millis()-empezo;
  if (tiempoDeZapateo<tdeJugador) {

    if (amp.analyze()>pisoAmp && estadoZapateo==0) {
      myPort.write('1');
      println("1");
      vidaMaquina=200;
      for(int i=0; i<60;i++){
dibujarLinea(random(0, 300)+20*i, 400,100);}
    } else if (amp.analyze()>pisoAmp && estadoZapateo==1) {
      myPort.write('1');
      println("1");
      vidaMaquina=200;
   for(int i=0; i<60;i++){
dibujarLinea(random(0, 300)+20*i, 500,190);}
    } else if (amp.analyze()>pisoAmp && estadoZapateo==2) {
      myPort.write('1');
      println("1");
      vidaMaquina=200;
   for(int i=0; i<60;i++){
dibujarLinea(random(0, 300)+20*i, 900,255);}
    } else {
      myPort.write('2');
      vidaMaquina--;
      println("vida= "+vidaMaquina);
    }
  } else {
    base.stop();
    tiempoDeZapateo=0;
    zapatear=false;
    respuestaM=true;
    estados=estados+1;
    setear=true;
  }
  if (vidaMaquina<1) {
    marcaDeTiempoReiniciar=millis();
    base.stop();
  }
}
void respuestaMaquina(int NumRespuesta) {
  myPort.write('0');

  if ( setear==true) {
    empezo=millis();
    setear=false;
    resp[NumRespuesta].play();
  }
  tiempoDeZapateo=millis()-empezo;
  if (tiempoDeZapateo<tdeMaquina[NumRespuesta]) {
  } else {
    base.stop();
    tiempoDeZapateo=0;
    zapatear=true;
    respuestaM=false;
    estados=estados+1;
    setear=true;
  }
}
void jugar() {
  float a;
  push();
  fill(255, 0, 0);
  if (vidaMaquina<1) {
    risa.play();
    estado="perdiste";
  } else if (estados==0&&zapatear==true&&respuestaM==false) {
    estadoZapateo=0;

    zapatear();
  } else if (estados==1&&zapatear==false&&respuestaM==true) {
    respuestaMaquina(0);
    a=volumenMaquinaZapateo1.analyze()*1000;
    for(int i=0; i<60;i++){
dibujarLineaMaquina(random(0, 300)+20*i, 900,255);}
  } else if (estados==2&&zapatear==true&&respuestaM==false) {
    estadoZapateo=1;

    zapatear();
  } else if (estados==3&&zapatear==false&&respuestaM==true) {
    respuestaMaquina(1);
    a=volumenMaquinaZapateo2.analyze()*1000;
   for(int i=0; i<60;i++){
dibujarLineaMaquina(random(0, 300)+20*i, 900,120);}
  } else  if (estados==4&&zapatear==true&&respuestaM==false) {
    estadoZapateo=2;

    zapatear();
  } else if (estados==5&&zapatear==false&&respuestaM==true) {
    maquinaMuere.play();
    estado="ganaste";
   myPort.write('4');
  }
  pop();
}

void dibujarLinea(float posX, int largoY, int opacidad) {
 char a='0';

  for (float i=10; i<random(largoY); i++) {
    if (i%2==0) {
      a='1';
    } else {
      a='0';
    }
    float j=i/2;
    if (j>100) {
      j=1;
    }
    fill(0, 255, 40, opacidad);
    textSize(j);
    text(a, posX, i*i/9);
  }
}

void dibujarLineaMaquina(float posX, int largoY, int opacidad) {
 char a='0';

  for (float i=10; i<random(largoY); i++) {
    if (i%2==0) {
      a='1';
    } else {
      a='0';
    }
    float j=i/2;
    if (j>100) {
      j=1;
    }
    fill(255, 0, 40, opacidad);
    textSize(j);
    text(a, posX, i*i/9);
  }
}
