latch165 = 8;
MISO = 6;          
CLK = 5;  
i = 0;
result = 0;

gpio.mode(latch165, gpio.OUTPUT);
gpio.write(latch165, gpio.LOW);
gpio.write(latch165, gpio.HIGH);
tmr.delay(100000);

gpio.mode(MISO, gpio.INPUT); 

gpio.mode(CLK, gpio.OUTPUT); 
gpio.write(CLK, gpio.LOW); 

gpio.write(latch165, gpio.LOW); 
tmr.delay(300000);
gpio.write(CLK, gpio.HIGH);  
tmr.delay(100000);
gpio.write(CLK, gpio.LOW);
tmr.delay(100000); 
gpio.write(latch165, gpio.HIGH); 

for i=8,1,-1 do
    result = gpio.read(MISO); 
    print(result); 
    gpio.write(CLK, gpio.HIGH); 
    tmr.delay(100000);
    gpio.write(CLK, gpio.LOW);
    tmr.delay(100000);
end;

--for i=10,1,-1 do gpio.write(CLK, gpio.HIGH) tmr.delay(100000) gpio.write(CLK, gpio.LOW) tmr.delay(100000) end
 