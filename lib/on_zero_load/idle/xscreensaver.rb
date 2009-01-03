require 'rubygems'

gem 'RubyInline', '>= 3.8'
require 'inline'


module OnZeroLoad
  module Idle
    class XScreenSaver
      # Query X11 DPMS extension for the current DPMS state of the first display.
      #
      # The returned hash contains the display state and the timeouts to set the display
      # to standby, suspend and off mode.
      #
      #  dpms_state -> { :state   => [ :on | :standby | :suspend | :off ],
      #                  :timeout => { :standby => Fixnum,
      #                                :suspend => Fixnum,
      #                                :off     => Fixnum } }
      #
      # Example:
      #
      #  dpms_state -> { :state   => :on,
      #                  :timeout => { :standby => 600,
      #                                :suspend => 900,
      #                                :off     => 1200 } }
      #
      # Just calls <tt>dpms_state_c()</tt> defined using RubyInline. It exists only
      # to let RDoc include this comment.
      def self.dpms_state
        # This is what dpms_state_c() looks like:
        # VALUE dpms_state_c() {
        #   static Display *display;
        #   int    dummy;
        #   CARD16 state;
        #   CARD16 standby, suspend, off;
        #   BOOL   on_off;
        #   VALUE  rb_hash;
        #   VALUE  rb_hash_timeout;
        #   VALUE  rb_state;
        #
        #   if (!display) {
        #     display = XOpenDisplay(0);
        #   }
        #
        #   if (DPMSQueryExtension(display, &dummy, &dummy)) {
        #     if (DPMSCapable(display)) {
        #       DPMSGetTimeouts(display, &standby, &suspend, &off);
        #       DPMSInfo(display, &state, &on_off);
        #     }
        #   }
        #
        #   switch (state) {
        #     case DPMSModeStandby: {
        #       rb_state = ID2SYM(rb_intern("standby"));
        #       break;
        #     }
        #     case DPMSModeSuspend: {
        #       rb_state = ID2SYM(rb_intern("suspend"));
        #       break;
        #     }
        #     case DPMSModeOff: {
        #       rb_state = ID2SYM(rb_intern("off"));
        #       break;
        #     }
        #     case DPMSModeOn:
        #     default: {
        #       rb_state = ID2SYM(rb_intern("on"));
        #       break;
        #     }
        #   }
        #
        #   rb_hash         = rb_hash_new();
        #   rb_hash_timeout = rb_hash_new();
        #
        #   rb_hash_aset(rb_hash, ID2SYM(rb_intern("state")), rb_state);
        #   rb_hash_aset(rb_hash, ID2SYM(rb_intern("timeout")), rb_hash_timeout);
        #
        #   rb_hash_aset(rb_hash_timeout, ID2SYM(rb_intern("standby")),
        #                                 INT2NUM(standby));
        #   rb_hash_aset(rb_hash_timeout, ID2SYM(rb_intern("suspend")),
        #                                 INT2NUM(suspend));
        #   rb_hash_aset(rb_hash_timeout, ID2SYM(rb_intern("off")),
        #                                 INT2NUM(off));
        #
        #   return rb_hash;
        # }
        self.dpms_state_c
      end

      class << self
        inline do |builder|
          builder.add_link_flags '-lX11 -lXss'
          builder.include '<X11/Xlib.h>'
          builder.include '<X11/extensions/dpms.h>'

          builder.c %{
            VALUE dpms_state_c() {
              static Display *display;
              int    dummy;
              CARD16 state;
              CARD16 standby, suspend, off;
              BOOL   on_off;
              VALUE  rb_hash;
              VALUE  rb_hash_timeout;
              VALUE  rb_state;

              if (!display) {
                display = XOpenDisplay(0);
              }

              if (DPMSQueryExtension(display, &dummy, &dummy)) {
                if (DPMSCapable(display)) {
                  DPMSGetTimeouts(display, &standby, &suspend, &off);
                  DPMSInfo(display, &state, &on_off);
                }
              }

              switch (state) {
                case DPMSModeStandby: {
                  rb_state = ID2SYM(rb_intern("standby"));
                  break;
                }
                case DPMSModeSuspend: {
                  rb_state = ID2SYM(rb_intern("suspend"));
                  break;
                }
                case DPMSModeOff: {
                  rb_state = ID2SYM(rb_intern("off"));
                  break;
                }
                case DPMSModeOn:
                default: {
                  rb_state = ID2SYM(rb_intern("on"));
                  break;
                }
              }

              rb_hash         = rb_hash_new();
              rb_hash_timeout = rb_hash_new();

              rb_hash_aset(rb_hash, ID2SYM(rb_intern("state")), rb_state);
              rb_hash_aset(rb_hash, ID2SYM(rb_intern("timeout")), rb_hash_timeout);

              rb_hash_aset(rb_hash_timeout, ID2SYM(rb_intern("standby")),
                                            INT2NUM(standby));
              rb_hash_aset(rb_hash_timeout, ID2SYM(rb_intern("suspend")),
                                            INT2NUM(suspend));
              rb_hash_aset(rb_hash_timeout, ID2SYM(rb_intern("off")),
                                            INT2NUM(off));

              return rb_hash;
            }
          }
        end
      end

      # Query X11 ScreenSaver extension for the time in milliseconds since the last user
      # input.
      #
      # Just calls <tt>idle_time_c()</tt> defined using RubyInline. It exists only to let
      # RDoc include this comment.
      def self.idle_time
        # This is what idle_time_c() looks like:
        #
        # VALUE idle_time_c() {
        #   static Display   *display;
        #   XScreenSaverInfo *info = XScreenSaverAllocInfo();
        #
        #   if (!display) {
        #     display = XOpenDisplay(0);
        #   }
        #
        #   XScreenSaverQueryInfo(display, DefaultRootWindow(display), info);
        #
        #   return INT2NUM(info->idle);
        # }
        self.idle_time_c
      end

      class << self
        inline do |builder|
          builder.add_link_flags '-lX11 -lXss'
          builder.include '<X11/extensions/scrnsaver.h>'

          builder.c %{
            VALUE idle_time_c() {
              static Display   *display;
              XScreenSaverInfo *info = XScreenSaverAllocInfo();

              if (!display) {
                display = XOpenDisplay(0);
              }

              XScreenSaverQueryInfo(display, DefaultRootWindow(display), info);

              return INT2NUM(info->idle);
            }
          }
        end
      end

      # Fixes the idle_time reported by X11 ScreenSaver extension.
      #
      # The reported idle_time is reset to zero each time the display switches between on,
      # standby, suspend and off state.
      #
      # To fix this, the sum of all timeouts upto the current display state is added to
      # the reported idle_time.
      #
      # The fix has its source in
      # xprintidle[http://www.dtek.chalmers.se/~henoch/text/xprintidle.html]. Freedesktop.org
      # has a {bug report}[http://bugs.freedesktop.org/show_bug.cgi?id=6439].
      def self.total_idle_time(idle_time = self.idle_time, dpms_state = self.dpms_state)
        state    = dpms_state[:state]
        timeouts = dpms_state[:timeout]
        diff     = {
          :on      =>  0,
          :standby =>  timeouts[:standby] * 1000,
          :suspend => (timeouts[:standby] +
                       timeouts[:suspend]) * 1000,
          :off     => (timeouts[:standby] +
                       timeouts[:suspend] +
                       timeouts[:off]) * 1000,
        }

        idle_time + diff[state]
      end
    end
  end
end
