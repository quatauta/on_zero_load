on_zero_load
===

https://github.com/quatauta/on_zero_load

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

    -h, --help                       Show this message
    -v, --version                    Print version and exit
    -V, --verbose                    Verbose output, print acual values and thresholds

Threshold options:

    -l, --load=<number>              System load average (default 0.1)
    -c, --cpu=<percents>             CPU usage (in %, default 5 %)
    -d, --disk=<byte>[/<sec>]        Harddisk throughput (in KiB/s)
    -n, --net=<bit>[/<sec>]          Network throughput (in Kib/s)
    -i, --idle=<time>                Idle time without user input (in s)

Predefined commands:

    -R, --reboot                     Reboot system ('sudo systemctl reboot')
    -S, --shutdown                   Halt system ('sudo systemctl poweroff')
    -H, --hibernate                  Hibernate/suspend system ('sudo systemctl hybrid-sleep')
    -B, --beep                       Let the system speaker beep ('beep')
```
