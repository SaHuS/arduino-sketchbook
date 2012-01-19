#include <VirtualWire.h>

int serIn; // var that will hold the bytes-in read from the serialB
char buf[100]; // array that will hold the different bytes 100=100characters;
                        // -> you must state how long the array will be else it won't work.
int serInIndx = 0; // index of serInString[] in which to insert the next incoming byte

void setup()
{
  vw_setup(4000); // Bits per sec
  vw_set_tx_pin(10);
  Serial.begin(9600);
  pinMode(4, OUTPUT);
  digitalWrite(4,HIGH);

}
void loop() {
  char *msg="0";
  vw_send((uint8_t *)msg, strlen(msg)); 
  vw_wait_tx(); 
  delay(500);
  msg="1";
  vw_send((uint8_t *)msg, strlen(msg)); 
  vw_wait_tx(); 
  delay(500);
  msg="2";
  vw_send((uint8_t *)msg, strlen(msg)); 
  vw_wait_tx(); 
  delay(500);
  msg="3";
  vw_send((uint8_t *)msg, strlen(msg)); 
  vw_wait_tx(); 
  delay(500);
  Serial.print(msg);
  
}
void loop2()
{
  
  if(Serial.available()>0){
    char *msg="";
    String command = readSerialString();
    

    if(command.equals("0")){
      msg="0";
    }
    else if(command.equals("1")){
      msg="1";
    }
    else if (command.equals("2")){
      msg="2";       
    }
    else if (command.equals("3")){
      msg="3";       
    }
    Serial.print(msg);
    vw_send((uint8_t *)msg, strlen(msg));  
    
  }
  
}

String readSerialString () {
    int sb;
    serInIndx=0;
    if(Serial.available()) {
       //Serial.print("reading Serial String: "); //optional confirmation
       while (Serial.available()){
          sb = Serial.read();
          buf[serInIndx] = sb;
          serInIndx++;
          //serialWrite(sb); //optional confirmation
       }
        buf[serInIndx] = '\0';
       String result = String(buf);
       return result;
    }
    else{
      return String("");
    }
}

