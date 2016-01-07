pin_r = 1
pin_g = 2
pin_b = 3

function led(r,g,b) 
    pwm.setduty(pin_r, r) 
    pwm.setduty(pin_g, g) 
    pwm.setduty(pin_b, b) 
end


pwm.setup(pin_r, 500, 512) 
pwm.setup(pin_g, 500, 512) 
pwm.setup(pin_b, 500, 512)
pwm.start(pin_r) 
pwm.start(pin_g) 
pwm.start(pin_b)
