on_zero_load
===

https://github.com/quatauta/on_zero_load

Daniel Schömer <mailto:daniel.schoemer@gmx.net>

Description
---
A ruby script to execute a command after the system load dropped below a certain
threshold. It can monitor the loadavg, harddisk and network activity. Support for
keyboard and mouse usage monitoring in X11 (like a screensaver) is planned.

I use it mostly to shutdown or hibernate my workstation after some long-running download
or compilation (yes, I'm on Gentoo/Linux).


Synopsis
---
In your favorite shell:

```
on-zero-load --sleep=10 --samples=3 --load=0.1:five --net=1Kib/s --cpu=5 -- sudo hibernate
```

It will check the five minute loadavg, average network and cpu utilization every 10
seconds. After the values are lower or equal than the given values for three times, the
command "sudo hibernate" is executed.

```
Usage: on_zero_load [OPTION]... -- [COMMAND] [COMMAND OPTION]...

Execute a command if the system load drops below given thresholds.

Standard options:

  -h, --help         Show this message
  -v, --version      Print version and exit
  -V, --verbose      Verbose output, print acual values and thresholds

Threshold options:

  -l, --load=<f>     System load average
  -c, --cpu=<s>      CPU usage
  -d, --disk=<s>     Harddisk throughput
  -n, --net=<s>      Network throughput
  -i, --input=<s>    Time without user input

Predefined commands:

  -R, --reboot       Reboot system, "sudo shutdown -r now"
  -S, --shutdown     Halt system, "sudo shutdown -h now"
  -H, --hibernate    Hibernate system, "sudo pm-hibernate"
  -B, --beep         Let the system speaker beep, "beep"
```
