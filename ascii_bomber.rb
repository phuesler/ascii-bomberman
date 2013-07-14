#!/usr/bin/env ruby -w
#
require 'curses'

Curses.noecho # do not show typed keys
Curses.init_screen
Curses.stdscr.keypad(true) # enable arrow keys
Curses.setpos(0, 0)
#loop do
  #char = Curses.getch
  #Curses.addstr(char.to_s)
#end
def game_loop
  loop do
    Curses.setpos(0, 0)
    Curses.addstr("render #{Time.now.to_s}")
    Curses.refresh
    sleep(0.25)
  end
end

game_loop
Curses.close_screen

