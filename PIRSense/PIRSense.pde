/*
  DigitalReadSerial
 Reads a digital input on pin 2, prints the result to the serial monitor 
 
 This example code is in the public domain.
 */

void setup() {
   Serial.begin(9600);
  pinMode(13, OUTPUT);
  pinMode(2, INPUT);
}

void loop() {
  int sensorValue = digitalRead(2);
  if(sensorValue==0){
      digitalWrite(13, LOW);
  }
  else{
      digitalWrite(13, HIGH);
  }

  Serial.println(sensorValue, DEC);
}



