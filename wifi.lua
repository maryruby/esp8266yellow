station_cfg={}
station_cfg.ssid="barmaglot"
station_cfg.pwd="br0Nenosets"
station_cfg.save=false
wifi.sta.config(station_cfg)
wifi.sta.connect()
ctg={ip = "192.168.0.111",
  netmask = "255.255.255.0",
  gateway = "192.168.0.1"}
wifi.sta.setip(cfg)
print(wifi.sta.getip())
print(wifi.sta.getmac())