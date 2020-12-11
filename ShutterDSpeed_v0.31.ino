//eFuse seeting clock 1MHz-internal, BOD-enable 1.8V.
int focus = 3;  //pb0 maby 3
int shutter =3; //pb1 maby 3
int ledshutter = 4; //pb4
int ledmode = 2 ; //pb2
int mode = 0;  //bp0
int start = 1; //pb1

unsigned long timeq;
int groupNo=1;

void setup() {

  
  // put your setup code here, to run once:
 pinMode(focus, OUTPUT);
 pinMode(shutter, OUTPUT);
 pinMode(ledmode,OUTPUT);
 pinMode (ledshutter, OUTPUT);
 pinMode(mode, INPUT);
 pinMode(start,INPUT);
 //pinMode(LED_BUILTIN, OUTPUT);
 
// Serial.begin(9600);

}

void loop() {
  // put your main code here, to run repeatedly:
   unsigned long delayms=1398; //500   ms for default
//  Serial.println("Time: ");
 //  digitalWrite(LED_BUILTIN, HIGH);
   timeq=millis();
 //  Serial.println(timeq);
 //  shutterFast(LOW);
  // shutterInterval(2.5); //delay 2.5s
  // digitalWrite(LED_BUILTIN,LOW);
 //  shutterFast(HIGH);
  // shutterInterval(2.5); //delay 2.5s
//   digitalWrite(ledshutter, HIGH);
//   delay(int(delayms/2));
 //  digitalWrite(LED_BUILTIN,LOW);
 //  digitalWrite(ledshutter, LOW);
//   shutterFast(LOW);
//   Serial.println("low");
//   delay(int(delayms/2));
   if (digitalRead(mode)==HIGH)
      { 
        delay(230);
        if (digitalRead(mode)==HIGH)
          {
            digitalWrite(ledmode,HIGH);
            delay(300);
            //delayms=delayms+100; //100ms per flash
            groupNo++;
            if(groupNo>=35) groupNo=35;
            digitalWrite(ledmode, LOW);
            delay(700);
          } else
           {
             delay(20);
             if(digitalRead(mode)==HIGH)
             {
               digitalWrite(ledmode,HIGH);
               delay(100);
               digitalWrite(ledmode,LOW);
               delay(100);
               //delayms=delayms-100;
               //delay(100);
               //null op
             }
            }
       }
       String mes1;
       mes1="Shutter Time " + delayms;
 //  Serial.println(mes1);
 //  Serial.println("mode done");
   int j, i=20, k; //20 continual frames
   String disms;
   String disms1="Delayms: ";
   if(digitalRead(start)==HIGH)
     {
      delay(600);
      if (digitalRead(start)==HIGH)
        {
         for(k=0;k<groupNo;k++) 
         {
          for (j=0;j<i;j++)
          {
            shutterFast(HIGH);
            digitalWrite(ledshutter, HIGH);
            delay(int(delayms/2*0.3)-24);
            shutterFast(LOW);
            digitalWrite(ledshutter, LOW);
            delay(int(delayms/2*0.7)-5);
            disms=disms1 + j ;
    //        Serial.println(disms);
          } 
         int m;
         for(m=0;m<i;m++)
          {
         //    digitalWrite(LED_BUILTIN,HIGH);
             delay(int(6800/i/2*0.35));
          //   digitalWrite(LED_BUILTIN,LOW);
             delay(int(6800/i/2*0.65));
          }
        // delay(13000); //13 seconds to write
        }
      }
    
     }
}

void shutterInterval(float interValTime)
{
   long int residueTms=0, primeTs;
   primeTs=int(interValTime)*1000;
   residueTms = int((interValTime*1000-primeTs));
   if (primeTs >=0) 
    {
      delay(primeTs*1000-30);
      
    } 
    delay(residueTms-2);
    
}


void shutterFast(bool State1)
{
  if (State1 == HIGH)
    {
      digitalWrite(focus, HIGH);
      delay(22);
      digitalWrite(shutter, HIGH);
      delay(2);
    }
  else
  {       
      digitalWrite(shutter, LOW);
      delay(3);
      digitalWrite(focus, LOW);
      delay(3);
  }

}
