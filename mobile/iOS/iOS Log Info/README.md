# iOS Log Info

## Capture console logs:
`sdsiosloginfo.exe -d > console.log`  
(To stop the capture session, press CTRL+C)

## Capture Crash logs:
`sdsioscrashlog.exe -e -k crash_logs`  
(To capture the crash log, create crash_logs directory)

## Pull Disk Usage:
`sdsdeviceinfo.exe -q com.apple.disk_usage -x > iOS_Disk_Usage.xml`  

## Pull Device Stats:
`sdsdeviceinfo.exe -x > iOS_Device_Stats.xml`
