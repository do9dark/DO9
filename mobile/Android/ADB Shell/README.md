# ADB Shell

## ADB Debugging
### Prints a list of all attached emulator/device:
`adb devices`  

### forward socket connections:
`adb forward <local> <remote>`  
`adb forward tcp:8000 tcp:9000 set up forwarding of host port 8000 to emulator/device port 9000`  
*Prerequisites: Enable USB debugging on the device.*

### terminates the adb server process:
`adb kill-server`  
*Notes: kill the server if it is running. (terminal adb.exe process)*
