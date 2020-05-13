wifi.setmode(wifi.STATION)
station_cfg={}
station_cfg.ssid="barmaglot"
station_cfg.pwd="br0Nenosets"
station_cfg.save=true
wifi.sta.config(station_cfg);
print(wifi.sta.getip());

led1 = 3;
led2 = 5;
button1 = 4;
gpio.mode(led1, gpio.OUTPUT)
gpio.mode(led2, gpio.OUTPUT)
restart=0;
lighton=0
gpio.mode(4, gpio.INPUT);
button1state = gpio.read(button1);
print("level pin 4 =", button1state);
    if button1state == 1 then
    button1message = 'Включено!' 
    else button1message = 'Выключено..'
    end;
gpio.write(led1, gpio.HIGH);
gpio.write(led2, gpio.HIGH);



print('\nAll About Circuits main.lua\n')
mytimer=tmr.create()
mytimer:alarm(1000, tmr.ALARM_AUTO, function()
   if wifi.sta.getip() == nil then
      print("Connecting to AP...\n")
   else
      ip, nm, gw=wifi.sta.getip()
      print("IP Info: \nIP Address: ",ip)
      print("Netmask: ",nm)
      print("Gateway Addr: ",gw,'\n')
      mytimer:stop(0)
   end
end)

 -- Start a simple http server
srv=net.createServer(net.TCP, 1000)
srv:listen(80,function(conn)
  conn:on("receive",function(client,request)
    print("request ",request)
     local buf = "";
        local _, _, method, path, vars = string.find(request, "([A-Z]+) (.+)?(.+) HTTP");
        if(method == nil)then
            _, _, method, path = string.find(request, "([A-Z]+) (.+) HTTP");
        end
        local _GET = {}
        if (vars ~= nil)then
            for k, v in string.gmatch(vars, "(%w+)=(%w+)&*") do
                _GET[k] = v
            end
        end
     conn:send(string.format('HTTP/1.1 200 OK\r\nConnection: keep-alive\r\nCache-Control: private, no-store\r\n\r\n\
   <!DOCTYPE HTML>\
<html>\
 <head>\
        <meta charset="UTF-8" />\
        <meta http-equiv="X-UA-Compatible" content="IE=edge,chrome=1"> \
        <meta name="viewport" content="width=device-width, initial-scale=1.0"> \
        <title>My control</title>\
   </head><body>\
        <div class="container">\
            <section class="color-2">\
                <p>\
                    <a href=\"?pin=ON1\"><button class="btn btn-4 btn-4a">Led1 ON</button></a>\
                    <a href=\"?pin=ON2\"><button class="btn btn-4 btn-4a">Led2 ON</button></a>\
                </p>\
                <p>\
                    <a href=\"?pin=OFF1\"><button class="btn btn-5 btn-5a">Led1 OFF</button></a>\
                    <a href=\"?pin=OFF2\"><button class="btn btn-5 btn-5a">Led2 OFF</button></a>\
                </p>\
                <p> My button is: %s </p>\
            </section>\
        </div>\
</body></html>', button1message))

  local _on,_off = "",""
        if(_GET.pin == "ON1")then
              lighton=0;
              gpio.write(led1, gpio.LOW);
        elseif(_GET.pin == "OFF1")then
              lighton=1;
              gpio.write(led1, gpio.HIGH);
        elseif(_GET.pin == "ON2")then
              lighton=0;
              gpio.write(led2, gpio.LOW);
        elseif(_GET.pin == "OFF2")then
              lighton=1;
              gpio.write(led2, gpio.HIGH);
        end
        
  conn:on("sent",function(conn) conn:close() end)
collectgarbage();
end)  
end)