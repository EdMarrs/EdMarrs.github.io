#include <MeMCore.h>

MeDCMotor motor1(M1); //Motor1 is Left Motor
MeDCMotor motor2(M2); //Motor2 is Right Motor
MeLineFollower lineFinder(PORT_2); 
MeBuzzer buzzer;
MeRGBLed led(0, 30);
void setup() {
  // put your setup code here, to run once:
    Serial.begin(9600);
    pinMode(7, INPUT); //Define button pin as input
    led.setpin(13);
    while (analogRead(7) > 100) { // While (Button is not pressed)
      delay(50);
    }
    buzzer.tone(200, 200);

}

void loop() {
  int sensorState = lineFinder.readSensors();
  switch(sensorState)
  {
    case S1_IN_S2_IN:
      Serial.println("S1_IN_S2_IN");
      motor1.run(100); //Motor1 (Left)  forward is +
      motor2.run(-100);  //Motor2 (Right) forward is -
      led.setColorAt(1, 0, 255, 0); //Set LED1 (RGBLED2) (LeftSide)
      led.setColorAt(0, 0, 255, 0); //Set LED0 (RGBLED1) (RightSide)
      led.show();

      break;
      
    case S1_IN_S2_OUT:
      motor1.run(100); //Motor1 (Left)  forward is +
      motor2.stop();  //Motor2 (Right) forward is -
      led.setColorAt(1, 0, 0, 0);   //Set LED1 (RGBLED2) (LeftSide)
      led.setColorAt(0, 0, 255, 0); //Set LED0 (RGBLED1) (RightSide)
      led.show();

      break;
      
    case S1_OUT_S2_IN:
      motor1.stop(); //Motor1 (Left)  forward is +
      motor2.run(-100);  //Motor2 (Right) forward is -
      led.setColorAt(1, 0, 255, 0); //Set LED1 (RGBLED2) (LeftSide)
      led.setColorAt(0, 0, 0, 0);   //Set LED0 (RGBLED1) (RightSide)
      led.show();

      break;
      
    case S1_OUT_S2_OUT:
      motor1.run(-100);
      motor2.run(100);
      led.setColorAt(1, 0, 0, 0); //Set LED1 (RGBLED2) (LeftSide)
      led.setColorAt(0, 0, 0, 0); //Set LED0 (RGBLED1) (RightSide)
      led.show();
      break;
      
    default:
      break;
  }
  
}
