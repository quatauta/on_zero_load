#!/usr/bin/env ruby

require 'inline'

module OnZeroLoad
  module Idle
    class XScreenSaver
      # Query X11 ScreenSaver extension for the time in milliseconds since the last user
      # input.
      #
      # Just calls <tt>_c_idle_time()</tt> defined using RubyInline. It exists only to let
      # RDoc include this comment.
      def self.idle_time
        # This is what _c_idle_time() looks like:
        #
        # VALUE _c_idle_time() {
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
        self._c_idle_time
      end

      class << self
        inline do |builder|
          builder.add_link_flags '-lX11 -lXss'
          builder.include '<X11/extensions/scrnsaver.h>'

          builder.c %{
            VALUE _c_idle_time() {
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

      # Query X11 DPMS extension for the current DPMS state of first display.
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
      # Just calls <tt>_c_dpms_state()</tt> defined using RubyInline. It exists only
      # to let RDoc include this comment.
      def self.dpms_state
        # This is what _c_dpms_state() looks like:
        # VALUE _c_dpms_state() {
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
        self._c_dpms_state
      end

      class << self
        inline do |builder|
          builder.add_link_flags '-lX11 -lXss'
          builder.include '<X11/Xlib.h>'
          builder.include '<X11/extensions/dpms.h>'

          builder.c %{
            VALUE _c_dpms_state() {
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

      def self.total_idle_time(dpms_state = self.dpms_state)
        diff = {
          :on      =>  0,
          :standby =>  dpms_state[:timeout][:standby] * 1000,
          :suspend => (dpms_state[:timeout][:standby] +
                       dpms_state[:timeout][:suspend]) * 1000,
          :off     => (dpms_state[:timeout][:standby] +
                       dpms_state[:timeout][:suspend] +
                       dpms_state[:timeout][:off]) * 1000,
        }

        self.idle_time + diff[dpms_state[:state]]
      end
    end
  end
end
