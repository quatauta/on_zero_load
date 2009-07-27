 on_zero_load
    by Daniel Schömer <daniel.schoemer@gmx.net>
    https://code.launchpad.net/~daniel-schoemer/+junk/on-zero-load_devel

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

To install the required gems, use the commands on a terminal/console. Omit +sudo+ to
install the gems in your <code>$HOME</code> gem repository.

=== Runtime

* Ruby Units - Simplify the handling of units for scientific calculations (http://ruby-units.rubyforge.org/ruby-units)
* Trollop - Commandline option parser for Ruby that just gets out of your way (http://trollop.rubyforge.org/)

 # sudo gem install ruby-units
 # sudo gem install trollop

=== Development

* Rake - Ruby Make (http://rake.rubyforge.org)
* RSpec - Behaviour driven development (BDD) framework for Ruby (http://rspec.rubyforge.org)
* Cucumba - A tool that can execute feature documentation a.k.a. RSpec stories (http://github.com/aslakhellesoy/cucumber/wikis)
* RDoc - Produces documentation for Ruby source files (http://rdoc.rubyforge.org)

 # sudo gem install rake
 # sudo gem install rspec
 # sudo gem install cucumba
 # sudo gem install rdoc

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
