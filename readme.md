# BTT Relay 1.2 Firmware (modified)
Modified BTT Relay 1.2 firmware for STC15F201S chip allowing to not only turn OFF the printer ... but also turn ON.
This feature was missing in original firmware and epic annoying, it required pushing Reset button every time you turn off the printer.
The modified firmware uses 3 seconds delay between ON/OFF or OFF/ON to avoid fast switching and sparking.

### Warning
`This device operates at mains voltage 230v!`
`You are using this software on your own risk.`

#### Remeber, you are using this software and doing this on your own responsibility.

## Build
- Download and install KEIL C51 (uVision) toolchain
- Add directory containing C51.exe to your PATH
- Run build.bat

## Upload
- Install python 3.x
- pip install stcgal
- Connect your board to any USB to Serial adapter
- Run upload.bat COM# where # is your COM port number
- Reset the board with reset button
