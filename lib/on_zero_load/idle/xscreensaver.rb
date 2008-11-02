#!/usr/bin/env ruby

require 'inline'

module OnZeroLoad
  module Idle
    class XScreenSaver
      class << self
        inline do |builder|
          builder.add_link_flags '-lX11 -lXss'
          builder.include '<X11/Xlib.h>'
          builder.include '<X11/extensions/dpms.h>'
          builder.include '<X11/extensions/scrnsaver.h>'

          builder.c %{
            VALUE idle_time() {
              static Display   *display;
              XScreenSaverInfo *info = XScreenSaverAllocInfo();

              if (!display) {
                display = XOpenDisplay(0);
              }

              XScreenSaverQueryInfo(display, DefaultRootWindow(display), info);

              return INT2NUM(info->idle);
            }
          }

          builder.c %{
            VALUE dpms_state() {
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
