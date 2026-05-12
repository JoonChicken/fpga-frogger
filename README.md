# FPGA Frogger

A Frogger clone running on an iCE40 UltraPlus FPGA on an [UPduino 3.0](https://github.com/tinyvision-ai-inc/upduino-v3.0), created as a final project for ES4: Intro to Digital Logic at Tufts University

**Authors:** Lauren Girouard, Joon Heo, Ethan Wienkamp, Justin Zhang

---

## Installation

### Software

**This program takes up a lot of space in the FPGA. There is no guarantee that the code will successfully flash to your FPGA if is has specs lower than that of the UPduino 3.0/3.1**

The apio project is already set up. If you are not using an UPduino 3.1, remember to follow step 5 and change the board type in apio.ini.

1. If not using UPduino 3.0/3.1, check if Apio supports your FPGA [here](https://fpgawars.github.io/apio/docs/supported-boards/). Note the board id that appears alongside the board information.
2. Install Apio using the instructions [here](https://fpgawars.github.io/apio/docs/installing-apio-cli/)
3. Ensure UPduino is connected to computer via USB and run `apio devices usb` to verify that apio can find your UPduino
    1. If not found, run `apio drivers install ftdi` to install driver
    2. If still not found, all hope is lost. Refer to apio docs for help.
4. Download source files from this repo and place them in a known directory on your computer
5. Check your board version
    * If using UPduino 3.1, you're good to go
    * If using UPduino 3.0, go to apio.ini and change `board = upduino31` to `board = upduino3`
    * If using another apio-supported board, go to apio.ini and change `board = upduino31` to whatever the board id you found in step 1.
6. Navigate to this directory and run `apio upload` to build and upload to the UPduino

### Hardware

