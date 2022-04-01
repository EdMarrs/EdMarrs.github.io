#include <MeMCore.h>

MeDCMotor motor1(M1); //Motor1 is Left Motor
MeDCMotor motor2(M2); //Motor2 is Right Motor
MeUltrasonicSensor ultrasonic(PORT_4);
MeLineFollower lineFinder(PORT_2); 
MeBuzzer buzzer;
MeRGBLed led(0, 30);
void setup() {
  // put your setup code here, to run once:
    Serial.begin(9600);
    pinMode(7, INPUT); //Define button pin as input
    led.setpin(13);
    led.setColorAt(1, 0, 0, 0); //Set LED1 (RGBLED2) (LeftSide)
    led.setColorAt(0, 0, 0, 0); //Set LED0 (RGBLED1) (RightSide)
    led.show();
    while (analogRead(7) > 100) { // While (Button is not pressed)
      delay(50);
    }
    buzzer.tone(200, 200);

}

void loop() {
  float dist=ultrasonic.distanceCm();
  Serial.println(dist);
   motor1.run(-1*(30-dist)*100);
   motor2.run((30-dist)*100);


   
   if(dist!=0 && dist<=29){
      led.setColorAt(1, 255/(29-dist), 0, 0); //Set LED1 (RGBLED2) (LeftSide)
      led.setColorAt(0, 255/(29-dist), 0, 0); //Set LED0 (RGBLED1) (RightSide)
   }
   else if(dist!=0 && dist>=31){
      led.setColorAt(1, 0, 0, 255/(dist-31)); //Set LED1 (RGBLED2) (LeftSide)
      led.setColorAt(0, 0, 0, 255/(dist-31)); //Set LED0 (RGBLED1) (RightSide)
   }
   else{
    led.setColorAt(1, 0, 255, 0); //Set LED1 (RGBLED2) (LeftSide)
    led.setColorAt(0, 0, 255, 0); //Set LED0 (RGBLED1) (RightSide)
   }
   led.show();

}
