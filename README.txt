 on_zero_load
    by Daniel Schömer <daniel.schoemer@gmx.net>
    FIXME (url)

== Description

A ruby script to execute a command after the system load dropped below a certain
threshold.  It can monitor the loadavg, harddisk and network activity.  Support for
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

== Requirements

=== Runtime

* Ruby Units - Simplify the handling of units for scientific calculations (http://ruby-units.rubyforge.org/ruby-units)
* Trollop - Commandline option parser for Ruby that just gets out of your way (http://trollop.rubyforge.org/)

 # sudo gem install ruby-units
 # sudo gem install trollop

=== Development

* Rake - Ruby Make (http://rake.rubyforge.org)
* RSpec - Behaviour driven development (BDD) framework for Ruby (http://rspec.rubyforge.org)
* Hanna¹ - A template for RDoc (http://github.com/mislav/hanna)

 # sudo gem install rake
 # sudo gem install rspec
 # sudo gem install --source http://gems.github.com mislav-hanna

¹optional dependencies

To add permanently add http://gems.github.com to gem sources:

 # sudo gem source -a http://gems.github.com

== Install

 # sudo gem install on_zero_load

== License

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
