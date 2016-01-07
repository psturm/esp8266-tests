-- setup I2c and connect display
function init_i2c_display()
    local sda = 3
    local scl = 4
    local sla = 0x3c
    i2c.setup(0, sda, scl, i2c.SLOW)
    disp = u8g.ssd1306_128x64_i2c(sla)
end

function prepare_display()
    disp:setFont(u8g.font_6x10)
    disp:setFontRefHeightExtendedText()
    disp:setDefaultForegroundColor()
    disp:setFontPosTop()
end

function write_text(text)
    print('Write: '..text)
    disp:firstPage()
    
    repeat
        disp:drawStr(0, 0, text)
    until disp:nextPage() == false
end


init_i2c_display()
prepare_display()
write_text('init ..');



pin_ds18 = 1

-- ow.select() is buggy on nodemcu 0.96
function ow_select_fix(pin_ds18, addr)
    ow.write(pin_ds18,0x55, 1) -- 0x55==search aka select command
    for i=1,8 do
        ow.write(pin_ds18,addr:byte(i), 1)
    end
end

ow.setup(pin_ds18)
count = 0
repeat
  count = count + 1
  addr = ow.reset_search(pin_ds18)
  addr = ow.search(pin_ds18)
  tmr.wdclr()
until((addr ~= nil) or (count > 100))
if (addr == nil) then
  print("No more addresses.")
else
  print(addr:byte(1,8))
  crc = ow.crc8(string.sub(addr,1,7))
  if (crc == addr:byte(8)) then
    if ((addr:byte(1) == 0x10) or (addr:byte(1) == 0x28)) then
        print("Device is a DS18S20 family device.")
        repeat
          ow.reset(pin_ds18)
          ow_select_fix(pin_ds18, addr)
          ow.write(pin_ds18, 0x44, 1)
          tmr.delay(1000000)
          present = ow.reset(pin_ds18)
          ow_select_fix(pin_ds18, addr)
          ow.write(pin_ds18,0xBE,1)
          print("P="..present)  
          data = nil
          data = string.char(ow.read(pin_ds18))
          for i = 1, 8 do
            data = data .. string.char(ow.read(pin_ds18))
          end
          print(data:byte(1,9))
          crc = ow.crc8(string.sub(data,1,8))
          print("CRC="..crc)
          if (crc == data:byte(9)) then
             t = (data:byte(1) + data:byte(2) * 256)

             -- handle negative temperatures
             if (t > 0x7fff) then
                t = t - 0x10000
             end

             if (addr:byte(1) == 0x28) then
                t = t * 625  -- DS18B20, 4 fractional bits
             else
                t = t * 5000 -- DS18S20, 1 fractional bit
             end

             local sign = ""
             if (t < 0) then
                 sign = "-"
                 t = -1 * t
             end

             -- Separate integral and decimal portions, for integer firmware only
             local t1 = string.format("%d", t / 10000)
             local t2 = string.format("%04u", t % 10000)
             local temp = sign .. t1 .. "." .. t2
             write_text("Temp " .. temp .. " C")
          end                   
          tmr.wdclr()
        until false
    else
      print("Device family is not recognized.")
    end
  else
    print("CRC is not valid!")
  end
end