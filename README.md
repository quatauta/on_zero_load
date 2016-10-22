on_zero_load

Daniel Schömer <mailto:daniel.schoemer@gmx.net>

https://code.launchpad.net/~daniel-schoemer/+junk/on-zero-load_devel

== Description

A ruby script to execute a command after the system load dropped below a certain
threshold. It can monitor the loadavg, harddisk and network activity. Support for
keyboard and mouse usage monitoring in X11 (like a screensaver) is planned.

I use it mostly to shutdown or hibernate my workstation after some long-running download
or compilation (yes, I'm on Gentoo/Linux).

Currently only for Linux 2.6, but I will support others on request, if I'm able to.
Patches welcome.

== Features/Problems

* FIXME (list of features or problems)

== Synopsis

In your shell:

 # on-zero-load --sleep=10 --samples=3 --load=0.1:five --net=1Kib/s --cpu=5 -- sudo hibernate

It will check the five minute loadavg, average network and cpu utilization every 10
seconds. After the values are lower or equal than the given values for three times, the
command "sudo hibernate" is executed.
