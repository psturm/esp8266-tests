# First steps: ESP8266

Some quick test scripts for an ESP8266 microncontroller (https://en.wikipedia.org/wiki/ESP8266)


## Setup

### flashing tools

Download https://github.com/themadinventor/esptool


```
sudo python esptool/esptool.py --port /dev/ttyUSB0  write_flash 0x00000 nodemcu_float_0.9.6-dev_20150704.bin


# if not responding at all, try http://bbs.nodemcu.com/t/nodemcu-devkit-bricked-cant-recover-reset-whats-the-proper-method/385/3
sudo python esptool/esptool.py --port /dev/ttyUSB0  write_flash 0x00000 nodemcu_float_0.9.6-dev_20150704.bin -fs 32m -fm dio -ff 40m
```


More detailed instructions: http://www.whatimade.today/flashing-the-nodemcu-firmware-on-the-esp8266-linux-guide/




### ESPlorer (IDE)

http://esp8266.ru/esplorer/ (needs sudo permissions, be aware!)

`sudo java -jar ESPlorer.jar`


## Resources

### NodeMCU

Full API: https://github.com/nodemcu/nodemcu-firmware/wiki/nodemcu_api_en


### LUA

unofficial faq: http://www.esp8266.com/wiki/doku.php?id=nodemcu-unofficial-faq


LUA quick reference: http://tylerneylon.com/a/learn-lua/


# hardware

short introduction on the hardware

* http://blog.nyl.io/esp8266-meets-nodemcu/
* http://www.instructables.com/id/Blink-for-ESP8266-native-like-arduino-using-Window/


# Websites

First steps, connecting everything and building a simple webserver: http://www.cnx-software.com/2015/10/29/getting-started-with-nodemcu-board-powered-by-esp8266-wisoc/

http://www.esp8266.com
