# frozen_string_literal: true

# vim:set fileencoding=utf-8:

require "inline"

module OnZeroLoad
  module Idle
    class XScreenSaver
      # Query the X11 DPMS extension for the current DPMS state of the first display.
      #
      # The returned hash contains the display state and the timeouts to set the display
      # to standby, suspend and off mode. If the connection to the X server can not be
      # opened, +nil+ is returned.
      #
      # The connection to the X server is defined by the +DISPLAY+ environment variable.
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
      #
      # @return [Hash] the DPMS state as symbol and the timeout values in milliseconds
      def self.dpms_state
        # This is what dpms_state_c() looks like:
        #
        # VALUE dpms_state_c() {
        #   Display *display;
        #   int      dummy;
        #   CARD16   state;
        #   CARD16   standby, suspend, off;
        #   BOOL     on_off;
        #   VALUE    rb_hash;
        #   VALUE    rb_hash_timeout;
        #   VALUE    rb_state;
        #
        #   if (!display) {
        #     display = XOpenDisplay(NULL);
        #   }
        #
        #   if (display) {
        #     if (DPMSQueryExtension(display, &dummy, &dummy)) {
        #       if (DPMSCapable(display)) {
        #         DPMSGetTimeouts(display, &standby, &suspend, &off);
        #         DPMSInfo(display, &state, &on_off);
        #       }
        #     }
        #
        #     switch (state) {
        #       case DPMSModeStandby: {
        #         rb_state = ID2SYM(rb_intern("standby"));
        #         break;
        #       }
        #       case DPMSModeSuspend: {
        #         rb_state = ID2SYM(rb_intern("suspend"));
        #         break;
        #       }
        #       case DPMSModeOff: {
        #         rb_state = ID2SYM(rb_intern("off"));
        #         break;
        #       }
        #       case DPMSModeOn:
        #       default: {
        #         rb_state = ID2SYM(rb_intern("on"));
        #         break;
        #       }
        #     }
        #
        #     rb_hash         = rb_hash_new();
        #     rb_hash_timeout = rb_hash_new();
        #     rb_hash_aset(rb_hash, ID2SYM(rb_intern("state")), rb_state);
        #     rb_hash_aset(rb_hash, ID2SYM(rb_intern("timeout")), rb_hash_timeout);
        #     rb_hash_aset(rb_hash_timeout, ID2SYM(rb_intern("standby")),
        #                                   INT2NUM(standby));
        #     rb_hash_aset(rb_hash_timeout, ID2SYM(rb_intern("suspend")),
        #                                   INT2NUM(suspend));
        #     rb_hash_aset(rb_hash_timeout, ID2SYM(rb_intern("off")),
        #                                   INT2NUM(off));
        #     XCloseDisplay(display);
        #     return rb_hash;
        #   } else {
        #     return Qnil;
        #   }
        # }
        dpms_state_c
      end

      self.class.inline do |builder|
        builder.add_link_flags "-lXext"
        builder.include "<X11/Xlib.h>"
        builder.include "<X11/extensions/Xext.h>"
        builder.include "<X11/extensions/dpms.h>"

        builder.c %{
          VALUE dpms_state_c() {
            Display *display;
            int      dummy;
            CARD16   state;
            CARD16   standby, suspend, off;
            BOOL     on_off;
            VALUE    rb_hash;
            VALUE    rb_hash_timeout;
            VALUE    rb_state;

            if (!display) {
              display = XOpenDisplay(NULL);
            }

            if (display) {
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
              XCloseDisplay(display);
              return rb_hash;
            } else {
              return Qnil;
            }
          }
        }
      end

      # Query the X11 ScreenSaver extension for the time since the last user input.
      #
      # The idle time in milliseconds is returned as number. If the connection to the X
      # server can not be opened, +nil+ is returned.
      #
      # The connection to the X server is defined by the +DISPLAY+ Environment variable.
      #
      # Just calls <tt>idle_time_c()</tt> defined using RubyInline. It exists only to let
      # RDoc include this comment.
      #
      # @return [Integer] the time in millisecons since the last user input
      def self.idle_time
        # This is what idle_time_c() looks like:
        #
        # VALUE idle_time_c() {
        #   Display          *display;
        #   XScreenSaverInfo *info;
        #   VALUE             idle;
        #
        #   if (!display) {
        #     display = XOpenDisplay(NULL);
        #   }
        #
        #   if (display) {
        #     info = XScreenSaverAllocInfo();
        #
        #     XScreenSaverQueryInfo(display, DefaultRootWindow(display), info);
        #
        #     idle = INT2NUM(info->idle);
        #
        #     XCloseDisplay(display);
        #
        #     return idle;
        #   } else {
        #     return Qnil;
        #   }
        # }
        idle_time_c
      end

      self.class.inline do |builder|
        builder.add_link_flags "-lXss"
        builder.include "<X11/extensions/scrnsaver.h>"

        builder.c %{
          VALUE idle_time_c() {
            Display          *display;
            XScreenSaverInfo *info;
            VALUE             idle;

            if (!display) {
              display = XOpenDisplay(NULL);
            }

            if (display) {
              info = XScreenSaverAllocInfo();
              XScreenSaverQueryInfo(display, DefaultRootWindow(display), info);
              idle = INT2NUM(info->idle);
              XCloseDisplay(display);
              return idle;
            } else {
              return Qnil;
            }
          }
        }
      end

      # Fixes the idle time reported by the X11 ScreenSaver extension.
      #
      # The reported idle time is reset to zero each time the display switches between on,
      # standby, suspend and off state.  To fix this, the sum of all timeouts upto the
      # current display state is added to the reported idle time.
      #
      # The fix has its source in
      # xprintidle[http://www.dtek.chalmers.se/~henoch/text/xprintidle.html]. Freedesktop.org
      # has a {bug report}[http://bugs.freedesktop.org/show_bug.cgi?id=6439].
      #
      # @param [Integer] idle_time the idle time in milliseconds as returned by {idle_time}
      # @param [Hash] dpms_state a hash as returned by {dpms_state}
      # @return [Integer] the corrected idle time
      #
      # @see idle_time
      # @see dpms_state
      def self.total_idle_time(idle_time = self.idle_time, dpms_state = self.dpms_state)
        state    = dpms_state[:state]
        timeouts = dpms_state[:timeout]
        diff     = {on: 0,
                    standby: timeouts[:standby] * 1000,
                    suspend: (timeouts[:standby] +
                               timeouts[:suspend]) * 1000,
                    off: (timeouts[:standby] +
                               timeouts[:suspend] +
                               timeouts[:off]) * 1000,}

        idle_time + diff[state]
      end
    end
  end
end
