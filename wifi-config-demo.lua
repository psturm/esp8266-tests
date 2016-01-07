print("WIFI control")

-- default wifi credentials, leave blank to create AP
cfg={}
cfg.ssid="XXX" 
cfg.pwd="YYY"


function conn_wifi(ssid, pwd)    
    print("Connecting to wifi with SSID="..ssid.." (pwd="..pwd..")")
    wifi.setmode(wifi.STATION)
    wifi.sta.config(ssid, pwd)
    wifi.sta.connect()

    time = tmr.now()
    timeout = 30000000
    
    tmr.alarm(1, 1000, 1, function() 
        local status = wifi.sta.status()
        print("Check status.. "..status)
        if status == 5 then 
            tmr.stop(1)
            ip, nm, gw = wifi.sta.getip()
            if ip == nil then
                print('CONNECTION FAILED, no IP')
            else
                print('Connection established. IP = ' .. ip)
            end
        else
            if tmr.now() - time > timeout then
                tmr.stop(1)
                print("Timeout. Failed to establish wifi connection. Status: "..status)
          end
        end 
    end)
end

function create_ap()    
    local ssid_ap = "ESP_"..node.chipid()
    local cfg_ap = {ssid=ssid_ap, pwd="12341234"}
    print("Creating AP with SSID="..cfg_ap.ssid.." PWD="..cfg_ap.pwd)
    wifi.setmode(wifi.SOFTAP)
    wifi.ap.config(cfg_ap)

    local ip_ap = wifi.ap.getip()
    print("Listening on "..ip_ap)

    sv = net.createServer(net.TCP, 30)
    sv:listen(80, function(c)
        c:on("receive", function(c, pl)
            get_creds_from_pl(pl, sv)
            local url = "http://"..ip_ap.."?SSID=XXX&PASSWORD=YYY"
            c:send("<h1>"..ssid_ap.." - wifi setup</h1>")
            c:send("To connect to an existing wifi:<br>")
            c:send("<a href='"..url.."'>"..url.."</a>")
        end)
        c:on("sent",function(conn) 
            c:close() 
        end) 
    end)
end

function get_creds_from_pl(pl, sv)
    print("**** payload ****")
    print(pl)

    ssid_start, ssid_end = string.find(pl, "SSID=")    
    if ssid_start and ssid_end then
        amper1_start, amper1_end = string.find(pl,"&", ssid_end+1)
        if amper1_start and amper1_end then
            http_start, http_end = string.find(pl,"HTTP/1.1", ssid_end+1)
            if http_start and http_end then
                ssid = string.sub(pl, ssid_end+1, amper1_start-1)
                password = string.sub(pl, amper1_end+10, http_start-2)
                print("ESP8266 connecting to SSID: " .. ssid .. " with PASSWORD: " .. password)

                if ssid and password then
                    sv:close()
                    tmr.delay(1000000)                    
                    conn_wifi(ssid, password)                    
                end    
            end    
        end
    end
    
end


if (cfg.ssid and cfg.pwd and cfg.ssid ~= "" and cfg.pwd ~= "") then
    print("Found default wifi credentials. Trying to connect ..")
    conn_wifi(cfg.ssid, cfg.pwd)
else
    print("Creating AP ..")     
    create_ap()
end

