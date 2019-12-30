# mprop
modify prop

## Usage
How to:

    mprop [prop key] [value]

Examples:

    bullhead:/ # cat default.prop | grep debug
    ro.debuggable=0
    
    bullhead:/ # getprop ro.debuggable
    0
    
    bullhead:/ # cd /data/local/tmp
    bullhead:/data/local/tmp # ./mprop ro.debuggable 1
    properties map area: b6f7a000-b6f9a000
    00000000  08 8d 00 00 19 01 00 00 50 52 4f 50 ab d0 6e fc  ........PROP??n?
    00000010  00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  ................
    ……
    
    bullhead:/ # cat default.prop | grep debug
    ro.debuggable=1
    
    bullhead:/ # getprop ro.debuggable
    1

Source: [https://github.com/wpvsyou/mprop/](https://github.com/wpvsyou/mprop/)
