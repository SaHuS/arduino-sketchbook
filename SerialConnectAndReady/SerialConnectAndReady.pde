/*
  DigitalReadSerial
 Reads a digital input on pin 2, prints the result to the serial monitor 
 
 This example code is in the public domain.
 */

void setup() {
   Serial.begin(115200);
   pinMode(2, INPUT);
   pinMode(3, INPUT);
   int sensorDigitalInput2Ant=-1;
   int sensorDigitalInput3Ant=-1;
}

void loop() {
  int sensorDigitalInput2 = digitalRead(2);
  int sensorDigitalInput3 = digitalRead(3);
  int analogInput0 = analogRead(0);
  Serial.print("I2:");
  Serial.print(sensorDigitalInput2, DEC);
  Serial.print(" I3:");
  Serial.print(sensorDigitalInput3, DEC);
  Serial.print(" A0:");
  Serial.println(analogInput0, DEC);

}



