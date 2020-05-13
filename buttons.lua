-- вводим имя сети и пароль сюда
station_cfg={}
station_cfg.ssid="barmaglot"
station_cfg.pwd="br0Memosets"

--cfg.save = false -- не сохранять настройки (по умолчанию true)
 
if (file.open('wificonf') == true)then
   ssid = string.gsub(file.readline(), "\n", "");
   pass = string.gsub(file.readline(), "\n", "");
   file.close();
end

wifi.setmode(wifi.STATION)
wifi.sta.config(cfg)
wifi.sta.autoconnect(1);
print('IP:',wifi.sta.getip());
--print('MAC:',wifi.sta.getmac());

led1 = 3
led2 = 4
gpio.mode(led1, gpio.OUTPUT)
gpio.mode(led2, gpio.OUTPUT)
restart=0;

gpio.write(led1, gpio.HIGH);
gpio.write(led2, gpio.HIGH);


t=0
tmr.alarm(0,1000, 1, function() t=t+1 if t>999 then t=0 end end)

srv=net.createServer(net.TCP, 1000)
srv:listen(80,function(conn)
    conn:on("receive",function(client,request)
    -- парсинг для отслеживания нажатий кнопок _GET
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
    -- это начало веб сайта
       -- в начале ставим <html><body>, в конце каждой строки знак \
   -- в конце последней строки не ставим знак \, а </body></html>
    conn:send('HTTP/1.1 200 OK\r\nConnection: keep-alive\r\nCache-Control: private, no-store\r\n\r\n\
   <!DOCTYPE HTML>\
<html>\
 <head>\
        <meta charset="UTF-8" />\
        <meta http-equiv="X-UA-Compatible" content="IE=edge,chrome=1"> \
        <meta name="viewport" content="width=device-width, initial-scale=1.0"> \
        <title>My control</title>\
   </head><body>\
        <div class="container">\
            <section class="color-1">\
                <p>\
                    <a href=\"?pin=ON1\"><button class="btn btn-4 btn-4a">Back ON</button></a>\
                    <a href=\"?pin=ON2\"><button class="btn btn-4 btn-4a">Bra ON</button></a>\
                </p>\
                <p>\
                    <a href=\"?pin=OFF1\"><button class="btn btn-5 btn-5a">Back OFF</button></a>\
                    <a href=\"?pin=OFF2\"><button class="btn btn-5 btn-5a">Bra OFF</button></a>\
                </p>\
            </section>\
        </div>\
</body></html>')
    -- это конец
    -- теперь опрос нажатых кнопок
        local _on,_off = "",""
        if(_GET.pin == "ON1")then
              gpio.write(led1, gpio.LOW);
        elseif(_GET.pin == "OFF1")then
              gpio.write(led1, gpio.HIGH);
        elseif(_GET.pin == "ON2")then
              gpio.write(led2, gpio.LOW);
        elseif(_GET.pin == "OFF2")then
              gpio.write(led2, gpio.HIGH);
        end
        
  
              
    conn:on("sent",function(conn) conn:close() end)
    collectgarbage();

    
    end)
    
end)
