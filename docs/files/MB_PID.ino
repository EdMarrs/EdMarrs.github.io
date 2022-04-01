#include <MeMCore.h>
#include <math.h>
MeDCMotor motor1(M1); //Motor1 is Left Motor
MeDCMotor motor2(M2); //Motor2 is Right Motor
MeUltrasonicSensor ultrasonic(PORT_4);
MeBuzzer buzzer;

double TotalError =0;
float leftTotal=0;
double KP = 100; //420;
double KI = 10; //70;
double KD = 0; //0;

void setup() {
  Serial.begin(9600);
    pinMode(7, INPUT); //Define button pin as input
    while (analogRead(7) > 100) { // While (Button is not pressed)
      delay(50);
    }
    buzzer.tone(200, 200);

}

void loop() {
        float Reading=ultrasonic.distanceCm();

        double LastError = 0;
        double DerivativeOfError = 0;
        double Error = 0;
        //Sensor input
        double Input = round(Reading);
        //How far we want to be from the wall
        double Goal = 15;
        //How much power the right wheel is getting
        double RightWheel = 0;

        //The amount of error
         Error =  Goal-Input;
         /*if(Double.isInfinite(Input)) {
          Error=0;
         }*/
         TotalError += Error;

         if(Error == 0 || (Error < 1 && Error > -1)) {
        
           TotalError = 0;
         }
         if (TotalError > 20) {
           TotalError = 20;

         }
         
         if (TotalError < -20) {
           
           TotalError = -20;
           
         }
         
         DerivativeOfError = (Error - LastError);
        
       //  RightWheel = (Error * KP) + (TotalError * KI) + (DerivativeOfError * KD);
         RightWheel = (Error * KP) + (-1 * (TotalError * KI));

         double power = 200;
         
         double temp = ((-1 * RightWheel) + 15)/ 15;
         
         power = 200 * temp;
         
         if (temp == 0) {
           
           power = 200;
           
         }
         
         if (power > 400) {
           
           power = 400;
           
         }
         
         else if(power < 100) {
           
           power = 0;
           
         }
         
         if(RightWheel > 15 ) {
           
           power = 0;

         }
         
         if(RightWheel < -15) {
           
           power = 400;
           
         }
         
           motor2.run(-1*(200/2));
           motor1.run(((int)(power))/2);
           
    }
         
