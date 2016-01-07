
-- setup I2c and connect display
function init_i2c_display()
    -- SDA and SCL can be assigned freely to available GPIOs
    local sda = 3
    local scl = 4
    local sla = 0x3c
    i2c.setup(0, sda, scl, i2c.SLOW)
    disp = u8g.ssd1306_128x64_i2c(sla)
end


-- graphic test components
function prepare()
    disp:setFont(u8g.font_6x10)
    -- disp:setFont(u8g.font_chikita)
    disp:setFontRefHeightExtendedText()
    disp:setDefaultForegroundColor()
    disp:setFontPosTop()
end

init_i2c_display()

print("--- Starting Graphics Test ---")

disp:firstPage()
prepare()    


repeat
    disp:drawStr(5, 5, "Hello", "World")
    disp:drawStr(20, 20, "WB Crew")
until disp:nextPage() == false


