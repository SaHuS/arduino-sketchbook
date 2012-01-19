/*
AC Light Control
 
 Updated by Robert Twomey <rtwomey@u.washington.edu>
 
 Changed zero-crossing detection to look for RISING edge rather
 than falling.  (originally it was only chopping the negative half
 of the AC wave form). 
 
 Also changed the dim_check() to turn on the Triac, leaving it on 
 until the zero_cross_detect() turn's it off.
 
 Ryan McLaughlin <ryanjmclaughlin@gmail.com>
 
 The hardware consists of an Triac to act as an A/C switch and 
 an opto-isolator to give us a zero-crossing reference.
 The software uses two interrupts to control dimming of the light.
 The first is a hardware interrupt to detect the zero-cross of
 the AC sine wave, the second is software based and always running 
 at 1/128 of the AC wave speed. After the zero-cross is detected 
 the function check to make sure the proper dimming level has been 
 reached and the light is turned on mid-wave, only providing 
 partial current and therefore dimming our AC load.
 
 Thanks to http://www.andrewkilpatrick.org/blog/?page_id=445 
 and http://www.hoelscher-hi.de/hendrik/english/dimmer.htm
 
 */

#include <TimerOne.h>           // Avaiable from http://www.arduino.cc/playground/Code/Timer1

volatile int i=0;               // Variable to use as a counter
volatile boolean zero_cross=0;  // Boolean to store a "switch" to tell us if we have crossed zero
int AC_pin = 9;                // Output to Opto Triac
int POT_pin = 0;             // Pot for testing the dimming
int LED = 4;                    // LED for testing
int dim = 0;                    // Dimming level (0-128)  0 = on, 128 = 0ff
int freqStep = 1000;    // Set the delay for the frequency of power (65 for 60Hz, 78 for 50Hz) per step (using 128 steps
// freqStep may need some adjustment depending on your power the formula 
// you need to us is (500000/AC_freq)/NumSteps = freqStep
// You could also write a seperate function to determine the freq

void setup() {                                      // Begin setup
  pinMode(AC_pin, OUTPUT);                          // Set the Triac pin as output
  pinMode(LED, OUTPUT);                             // Set the LED pin as output
  attachInterrupt(1, zero_cross_detect, RISING);   // Attach an Interupt to Pin 2 (interupt 0) for Zero Cross Detection
  Timer1.initialize(freqStep);                      // Initialize TimerOne library for the freq we need
  Timer1.attachInterrupt(dim_check, freqStep);   
  Serial.begin(9600);  
  // Use the TimerOne Library to attach an interrupt
  // to the function we use to check to see if it is 
  // the right time to fire the triac.  This function 
  // will now run every freqStep in microseconds.                                            
}

void zero_cross_detect() {    
  zero_cross = true;               // set the boolean to true to tell our dimming function that a zero cross has occured
  i=0;
  digitalWrite(AC_pin, LOW);
}                                 

// Function will fire the triac at the proper time
void dim_check() {                   
  if(zero_cross == true) {              
    if(i>=dim) {                     
      digitalWrite(AC_pin, HIGH);       
      i=0;                         
      zero_cross = false;                
    } 
    else {
      i++;                           
    }                                
  }                                  
}                                   

void loop() {
  dim=0;  
  for(int fadeValue = 0 ; fadeValue <= 127; fadeValue +=5) { 
    dim=100;
    analogWrite(LED, dim);
    Serial.println(dim);   
    // wait for 30 milliseconds to see the dimming effect    
    delay(50);                            
  } 
   // fade out from max to min in increments of 5 points:
  for(int fadeValue = 127 ; fadeValue >= 0; fadeValue -=5) { 
    dim=127;
    analogWrite(LED, dim);
    Serial.println(dim);   
   delay(50);    
  } 

}



