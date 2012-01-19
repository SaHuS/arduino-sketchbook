/* Copyright 2011 Lex Talionis
 
 This sketch uses a 'Random Phase' or 'Non Zero Crossing' SSR (Im using 
 the Omron G3MC-202PL DC5) to act as an A/C switch and an opto-isolataed 
 AC zero crossing dectector (the H11AA1) to give us a zero-crossing 
 reference. This allows the arduino to dim lights, change the temp of 
 heaters & speed control AC motors.
 
 The software uses dual interrupts (both triggered by Timer1) to control 
 how much of the AC wave the load receives. The first interrupt, 
 zero_cross_detect(), is triggered by the Zero Cross detector on pin 3 
 (aka IRQ1). It resets Timer1's counter and attaches nowIsTheTime to a 
 new interrupt to be fired midway though the AC cycle. Control flows back 
 to the loop until we have waited the specified time. Then nowIsTheTime 
 pulses the AC_PIN high long enough for the SSR to open, and returns 
 control to the loop.
 
 
 This program is free software: you can redistribute it and/or modify
 it under the terms of the GNU General Public License as published by
 the Free Software Foundation, either version 3 of the License, or
 (at your option) any later version.
 
 This program is distributed in the hope that it will be useful,
 but WITHOUT ANY WARRANTY; without even the implied warranty of
 MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 GNU General Public License for more details.
 
 You should have received a copy of the GNU General Public License
 along with this program.  If not, see <http://www.gnu.org/licenses/>.
 
 
 Based on:
 AC Light Control by Ryan McLaughlin <ryanjmclaughlin@gmail.com>
 http://www.arduino.cc/cgi-bin/yabb2/YaBB.pl?num=1230333861
 
 Thanks to http://www.andrewkilpatrick.org/blog/?page_id=445 
 and http://www.hoelscher-hi.de/hendrik/english/dimmer.htm
 
 Circut Diagram and more information available at:
 http://arduino.cc/playground/Code/ACPhaseControl
 
 */

#include <TimerOne.h>	// Avaiable from http://www.arduino.cc/playground/Code/Timer1
#define FREQ 50 	// 60Hz power in these parts
#define AC_PIN 9	// Output to Opto Triac
#define LED 13		// builtin LED for testing
#define VERBOSE 0	// can has talk back?
#define NO 0
#define ON 1
#define OFF 2

#define DEBUG_PIN 13	//scope this pin to measure the total time for the intrupt to run
int inc=1;

volatile byte state = NO;	// controls what interrupt should be 
//attached or detached while in the main loop
double wait = 3276700000;	//find the squareroot of this in your spare time please


unsigned long int period = 1000000 / (2 * FREQ);//The Timerone PWM period in uS, 60Hz = 8333 uS

unsigned int onTime = 0;	// the calculated time the triac is conducting
unsigned int offTime = period-onTime;	//the time to idle low on the AC_PIN

int dim=20;
void setup()
{

  Serial.begin(115200);	//start the serial port at 115200 baud we want
  Serial.println("AC Motor Control v1");	//the max speed here so any
  #ifdef VERBOSE		//debugging output wont slow down our time sensitive interrupt
  Serial.println("----- VERBOSE -----");	// feeling talkative?
  #endif
  pinMode(AC_PIN, OUTPUT);		// Set the Triac pin as output
  pinMode(LED, OUTPUT);
  attachInterrupt(1, zero_cross_detect, RISING); 	// Attach an Interupt to Pin 3 (interupt 1) for Zero Cross Detection
  Timer1.initialize(period);
//	Timer1.disablePwm(9);
  Timer1.disablePwm(10);
  digitalWrite(AC_PIN, LOW);
} 

void zero_cross_detect()	// function to be fired at the zero crossing.  This function
{				// keeps the AC_PIN full on or full off if we are at max or min
  // Serial.println(" zero_cross_detect");
  Timer1.restart();	// or attaches nowIsTheTime to fire at the right time.
  state=NO;
  if (dim<=5)			//if off time is very small
  {
    digitalWrite(AC_PIN, LOW);	//stay on all the time
  }
  else if (dim>=95) {		//if offTime is large
    digitalWrite(AC_PIN, HIGH);	//just stay off all the time
  }
  else	//otherwise we want the motor at some middle setting
  {
    state=OFF;
    digitalWrite(AC_PIN,LOW);
    
  }
}		// End zero_cross_detect

void nowIsTheTime ()
{
  Serial.println(" nowIsTheTime");
  state=ON;
  digitalWrite(AC_PIN,HIGH);
}

void loop() {			// Non time sensitive tasks - read the serial port
  dim=dim+inc;
  if(dim>=100){
    inc=-5;
  }
  else if(dim<=0){
    inc=5;
  }
  onTime = map(dim, 0, 100, 0, period);	// re scale the value from hex to uSec 
  offTime = period - onTime;			// off is the inverse of on, yay!
  Serial.print("\tonTime:");
  Serial.print(onTime);
  Serial.print("\toffTime:");
  Serial.println(offTime);
  delay(300);
  //  //no input, so do nothing
      if(state==OFF)	//its before the turn on time
      {
      Serial.println("OFF");
      Timer1.attachInterrupt(nowIsTheTime,offTime);
      state=NO;
      }
      else if(state==ON)	//its after turn on time
      {
        Serial.println("ON");
        Timer1.detachInterrupt();
        state=NO;
      } else Serial.println("NO");
      

}





