-- pin connected to VCC via Resistor (100kOhm)
-- "taster" connects pin to cathode

pin_btn = 1

gpio.mode(pin_btn, gpio.INPUT, gpio.PULLUP)


function check_btn()
    val = gpio.read(pin_btn)
    
    if val == gpio.HIGH then
        print("HIGH")
    else
        print("LOW")
    end
end


tmr.alarm(0, 1000, 1, function() 
    check_btn()
end)

