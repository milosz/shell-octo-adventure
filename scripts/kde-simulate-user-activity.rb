#!/usr/bin/env ruby
# use Inhibit and UnInhibit methods to suppress screensaver

require 'dbus'

session_bus  = DBus::SessionBus.instance
screen_saver = session_bus.service("org.freedesktop.ScreenSaver").object("/ScreenSaver");
screen_saver.introspect
screen_saver.default_iface="org.freedesktop.ScreenSaver";

chrome_check="top -n1 | awk \'$12 ~ /chrome/ {SUM += $9} END {print SUM}\'"
play_sound="play -q /usr/share/sounds/KDE-Window-All-Desktops-Not.ogg"
cookie = nil

loop do
  # read google chrome cpu usage
  ret=%x[#{chrome_check}]

  if ret.to_i > 5 then
    # google chrome cpu usage is greater than 5 so suspend screensaver
    if cookie == nil then
      cookie = screen_saver.Inhibit("google-chrome", "playing video").first
    end
  else
    # google chrome cpu usage is less than 6 so resume normal screensaver behaviour
    if cookie != nil
      screen_saver.UnInhibit(cookie)
      cookie = nil
      %x[#{play_sound}]
    end
  end

  # repeat loop every 1 minute
  sleep 60
end
