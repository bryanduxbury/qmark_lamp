# Basic configuration #

## Download Arduino 0023 ##

Go [here](http://arduino.cc/en/Main/Software) and download version 0023.

## Download and install the tiny core ##

Download arduino-tiny-0022-0008.zip from this directory, extract it, and then follow the installation instructions in the readme file.

## Modify boards.txt to add our target uC ##

We use a custom board configuration. Add the following to your boards.txt (which lives in the dir identified in the tiny-core readme):

>attiny44at8.name=ATtiny44 @ 8 MHz  (external oscillator; BOD disabled) >> BRYAN <<
>
>attiny44at8.upload.using=arduino:arduinoisp
>
>attiny44at8.upload.maximum_size=4096
>
>attiny44at8.bootloader.low_fuses=0xE2
>attiny44at8.bootloader.high_fuses=0xD7
>attiny44at8.bootloader.extended_fuses=0xFF
>attiny44at8.bootloader.path=empty
>attiny44at8.bootloader.file=empty84at8.hex
>
>attiny44at8.bootloader.unlock_bits=0xFF
>attiny44at8.bootloader.lock_bits=0xFF
>
>attiny44at8.build.mcu=attiny44
>attiny44at8.build.f_cpu=8000000L
>attiny44at8.build.core=tiny

## Install the CapSense library ##

Download the CapSense library from this directory and unzip it. Copy the extracted directory into the Arduino/hardware/libraries/ directory.

## Compile the firmware ##

Open Arduino 0023 and then open the firmware_2 sketch.

From the Tools menu, select Boards, then choose "ATtiny44 @ 8 MHz  (external oscillator; BOD disabled) >> BRYAN <<".

You should be able to click the Verify button and have the sketch compile with no errors.

# Setting up the jig to program boards directly #

The programming jig can be set up as a ArduinoISP for the purpose of quickly testing code changes.

First, download and install Arduino 1.0.1 or newer.

Next, under the File menu, select Examples and then ArduinoISP. 

Next, connect the programming jig to your computer via the USB cable. The toggle switch near the USB port should be "out". Click upload in the Arduino UI.

When flashing is complete, push the toggle switch back to "in."

Finally, to upload a sketch, place the completed PCBA into the programming jig, press down to make contact, and then click Upload from within Arduino 0023 with the firmware_2 sketch loaded.

# Setting up the jig to program boards without a computer #

Instructions forthcoming.