 on_zero_load
    by Daniel Schömer <daniel.schoemer@gmx.net>
    FIXME (url)

== DESCRIPTION:

A ruby script to execute a command after the system load dropped below a certain
threshold.  It can monitor the loadavg, harddisk and network activity.  Support for
keyboard and mouse usage monitoring in X11 (like a screensaver) is planned.

I use it mostly to shutdown or hibernate my workstation after some long-running download
or compilation (yes, I'm on Gentoo/Linux).

Currently only for Linux 2.6, but I will support others on request, if I'm able to.
Patches welcome.

== FEATURES/PROBLEMS:

* FIXME (list of features or problems)

== SYNOPSIS:

In your shell:

 # on-zero-load --sleep=10 --samples=3 --load=0.1:five --net=1Kib/s --cpu=5 -- sudo hibernate

It will check the five minute loadavg, average network and cpu utilization every 10
seconds. After the values are lower or equal than the given values for three times, the
command "sudo hibernate" is executed.

== REQUIREMENTS:

=== Runtime

* +main+, http://rubyforge.org/projects/codeforpeople
* <tt>ruby-units</tt>, http://ruby-units.rubyforge.org/ruby-units

=== Development

* +rake+, http://rake.rubyforge.org
* +rspec+, http://rspec.rubyforge.org

== INSTALL:

 # sudo gem install on_zero_load

== LICENSE:

(The MIT License)

Copyright (c) 2008 Daniel Schömer

Permission is hereby granted, free of charge, to any person obtaining
a copy of this software and associated documentation files (the
'Software'), to deal in the Software without restriction, including
without limitation the rights to use, copy, modify, merge, publish,
distribute, sublicense, and/or sell copies of the Software, and to
permit persons to whom the Software is furnished to do so, subject to
the following conditions:

The above copyright notice and this permission notice shall be
included in all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED 'AS IS', WITHOUT WARRANTY OF ANY KIND,
EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF
MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT.
IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY
CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT,
TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE
SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
