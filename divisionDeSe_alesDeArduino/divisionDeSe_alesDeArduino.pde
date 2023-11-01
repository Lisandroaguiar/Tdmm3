import processing.serial.*;
Serial myPort;



void setup(){
size(300,300);
myPort= new Serial(this,Serial.list()[0],9600);
println(Serial.list());
myPort.bufferUntil('\n');
}


void draw(){

background(255);
String inString= myPort.readStringUntil('\n');
if(inString != null){ int [] values=int(split(inString,","));

println(values[0],values[1],values[2]);
}
}
