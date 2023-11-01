/*
Diseño y Desarrollo de Interfaces - Docente: Jorge Luis Crowe:
El siguiente ejemplo mapea el valor leido en la entrada analógica 2 (GPIO 28)
y lo ejecuta como frecuencia mediante la función tone() en el pin 19.
En el GPIO 28 se configura un divisor resistivo con un LDR (a positivo) y 
una resistencia de 10K (a GND)
*/
int salida = 19;
int objetos = A1;   // Circulo Grande
int objetos2 = A2;  // Circulo Mediano
int objetos3 = A3;  // Circulo Chico
int umbral = 80;
int estadoCirculoChico;
int estadoCirculoMediano;
int estadoCirculoGrande;
int estadoGeneral=1;
void setup() {
  Serial.begin(9600);
}

void loop() {

  int lecturaObjetos = analogRead(objetos);
  int lecturaObjetos2 = analogRead(objetos2);
  int lecturaObjetos3 = analogRead(objetos3);

  if (lecturaObjetos3 > 595 || lecturaObjetos3 < 330 && lecturaObjetos3 > 30) {
    estadoCirculoChico = 1;
  }
  if (lecturaObjetos3 < 595 && lecturaObjetos3 > 465 || lecturaObjetos3 > 339 && lecturaObjetos3 < 390) {
    estadoCirculoChico = 2;
  }
  if (lecturaObjetos3 < 465 && lecturaObjetos3 > 383) {
    estadoCirculoChico = 3;
  }

  if (lecturaObjetos2 > 572 || lecturaObjetos2 < 334 && lecturaObjetos2 > 30) {
    estadoCirculoMediano = 1;
  }
  if (lecturaObjetos2 < 572 && lecturaObjetos2 > 452 || lecturaObjetos2 > 334 && lecturaObjetos2 < 381) {
    estadoCirculoMediano = 2;
  }
  if (lecturaObjetos2 < 452 && lecturaObjetos2 > 381) {
    estadoCirculoMediano = 3;
  }

  if (lecturaObjetos > 547 || lecturaObjetos < 261 && lecturaObjetos > 30) {
    estadoCirculoGrande = 1;
  }
  if (lecturaObjetos < 547 && lecturaObjetos > 397 || lecturaObjetos > 261 && lecturaObjetos < 314) {
    estadoCirculoGrande = 2;
  }
  if (lecturaObjetos < 397 && lecturaObjetos > 314) {
    estadoCirculoGrande = 3;
  }

  if (estadoCirculoGrande == 3 && estadoCirculoMediano == 3 || estadoCirculoChico == 3 && estadoCirculoMediano == 3  ||estadoCirculoChico == 3 && estadoCirculoGrande == 3) {
    estadoGeneral = 3;
  } else if (estadoCirculoGrande == 2 && estadoCirculoMediano == 2  || estadoCirculoChico == 2 && estadoCirculoMediano == 2  ||estadoCirculoChico == 2 && estadoCirculoGrande == 2) {
    estadoGeneral = 2;
  } else if (estadoCirculoGrande == 1 && estadoCirculoMediano == 1 || estadoCirculoChico == 1 && estadoCirculoMediano == 1 ||estadoCirculoChico == 1 && estadoCirculoGrande == 1) {
    estadoGeneral = 1;
  }
  else(estadoGeneral=0);
//Serial.write(estadoGeneral);
Serial.print(estadoCirculoChico);
Serial.print(",");
Serial.print(estadoCirculoMediano);
Serial.print(",");
Serial.print(estadoCirculoGrande);
Serial.print(",");
Serial.println();

delay(100);
}
