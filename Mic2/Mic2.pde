#include "fix_fft.h"
char im[128];
char data[128];
void setup(){
    Serial.begin(115200);
}
void loop(){
  int static i = 0;
  static long tt;
  int val;

  if (millis() > tt){
    if (i < 128){
      val = analogRead(A0);
      data[i] = val - 1024;
      im[i] = 0;
      i++;  

    }
    else{
      //this could be done with the fix_fftr function without the im array.
      fix_fft(data,im,7,0);
      // I am only interessted in the absolute value of the transformation
      int maxim = 0;
      int maxIndex=-1;
      for (i=0; i< 64;i++){
        data[i] = sqrt(data[i] * data[i] + im[i] * im[i]);
        Serial.print(data[i],DEC);
        Serial.print(" ");
        //if(data[i]>maxim){
        //  maxim=data[i];
        //  maxIndex=i;
        //}
      }
      //light();
      Serial.println();

    }

    tt = millis();
  }
} 




