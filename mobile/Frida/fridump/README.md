# fridump

Fridump (v0.1) is an open source memory dumping tool, primarily aimed to penetration testers and developers. Fridump is using the Frida framework to dump accessible memory addresses from any platform supported. It can be used from a Windows, Linux or Mac OS X system to dump the memory of an iOS, Android or Windows application.

## Usage
How to:

    fridump [-h] [-o dir] [-U] [-p] [-v] [-r] [-s] [--max-size bytes] process

The following are the main flags that can be used with fridump:

      positional arguments:
      process            the process that you will be injecting to

      optional arguments:
      -h, --help         show this help message and exit
      -o dir, --out dir  provide full output directory path. (def: 'dump_process')
      -U, --usb          device connected over usb
      -p, --pid          pid instead of process name
      -v, --verbose      verbose
      -r, --read-only    dump read-only parts of memory. More data, more errors
      -s, --strings      run strings on all dump files. Saved in output dir.
      --max-size bytes   maximum size of dump file in bytes (def: 20971520)

To find the name of a local process, you can use:

      frida-ps
For a process that is running on a USB connected device, you can use:

      frida-ps -U

Examples:

      fridump -U Safari   -   Dump the memory of an iOS device associated with the Safari app
      fridump -U -p 31337   -   Dump the memory of a device associated with 31337(pid)
      fridump -U -s com.example.WebApp   -  Dump the memory of an Android device and run strings on all dump files
      fridump -r -o [full_path]  -  Dump the memory of a local application and save it to the specified directory
      
Source: [https://github.com/Nightbringer21/fridump/](https://github.com/Nightbringer21/fridump/)

