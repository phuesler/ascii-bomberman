#!/usr/bin/env ruby -w
#
require 'curses'
require_relative 'game'

def read_keyboard_input(input_buffer)
  Thread.new do
    loop do
      input_buffer << Curses.getch
    end
  end
end
def init_curses
  Curses.noecho # do not show typed keys
  Curses.init_screen
  Curses.stdscr.keypad(true) # enable arrow keys
end

def game_loop(input_buffer)
  game = Game.new(11, 7)
  Thread.new do
    loop do
      game.display
      sleep(0.25)
    end
  end
end

def run
  begin
    init_curses
    input_buffer = []
    keyboard = read_keyboard_input(input_buffer)
    game = game_loop(input_buffer)
    keyboard.join
    game.join
  ensure
    Curses.close_screen
    puts 'ENSURE'
  end
end

run
