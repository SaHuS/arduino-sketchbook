#include <VirtualWire.h>
int PORT_0=7;
int PORT_1=6;
int PORT_2=5;
int PORT_3=4;
static int TAMANY_ARRAY=10;
boolean aEstat[10];
boolean APAGAT=false;
boolean ENCES=true;
int PORT_RF=2;
uint8_t buf[VW_MAX_MESSAGE_LEN];
uint8_t buflen = VW_MAX_MESSAGE_LEN;

String sBuffer;
void setup()
{
    for (int i=0;i<TAMANY_ARRAY;i++) aEstat[i]=APAGAT;
    pinMode(PORT_0, OUTPUT);
    pinMode(PORT_1, OUTPUT);
    pinMode(PORT_2, OUTPUT);
    pinMode(PORT_3, OUTPUT);
    Serial.begin(9600);	// Debugging only
    Serial.println("setup");
    vw_set_rx_pin(PORT_RF);
    vw_setup(4000);	 // Bits per sec
    vw_rx_start();       // Start the receiver PLL running
}

void loop()
{
  
  vw_wait_rx();
  if (vw_get_message(buf, &buflen)) // Non-blocking
  {
    int port=parse();
    if (aEstat[port]==ENCES){
      apagar(port);
      Serial.print("OFF:");
    }
    else{
      encendre(port);
      Serial.print("ON:");
    }
    Serial.print(port);
    Serial.println();
  }
}
  int parse() {
    sBuffer=String((char *)buf);
    int port;
    if (sBuffer.equals("0")) {
        port=PORT_0;
     } else if (sBuffer.equals("1")) {
        port=PORT_1;
     } else if (sBuffer.equals("2")) {
        port=PORT_2;
     } else if (sBuffer.equals("3")) {
        port=PORT_3;
     }
     else port=-1;
    return port;
  }
 void encendre (int port) {
      digitalWrite(port, HIGH);   // set the LED on
      delay(1000);              // wait for a second
      aEstat[port]=ENCES;

 }
 void apagar (int port) {
      digitalWrite(port, LOW);    // set the LED off
      delay(1000);   
      aEstat[port]=APAGAT;
 }
