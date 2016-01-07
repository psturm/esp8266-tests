
function blink3()
    for i = 1, 3 do
        gpio.write(0, gpio.LOW)
        tmr.delay(200000)
        gpio.write(0, gpio.HIGH)
        tmr.delay(100000)
    end
end

blink3()

wifi.setmode(wifi.STATION)

-- print ap list
function listap(t)
      for ssid,v in pairs(t) do
        authmode, rssi, bssid, channel = 
          string.match(v, "(%d),(-?%d+),(%x%x:%x%x:%x%x:%x%x:%x%x:%x%x),(%d+)")
        print(ssid,authmode,rssi,bssid,channel)
      end
end      
-- wifi.sta.getap(listap)

wifi.sta.config("XXX","YYY")
wifi.sta.connect()

tmr.delay(2000000)
print('Wifi status: ' .. wifi.sta.status())
tmr.delay(2000000)

ip, nm, gw=wifi.sta.getip()

if ip == nil then
    print('NO CONNECTION')    
else
    print('Connection established. IP = ' .. ip)
end

srv=net.createServer(net.TCP)
srv:listen(80,function(conn)
  conn:on("receive",function(conn,payload)
    print(payload)
    conn:send("<h1> Hello, NodeMCU!!! </h1>")
  end)
  conn:on("sent",function(conn) conn:close() end)
end)
