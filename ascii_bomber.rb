#!/usr/bin/env ruby -w
#
require 'curses'
require_relative 'game'
require_relative 'ring_buffer'

def read_keyboard_input(input_buffer)
  t = Thread.new do
    loop do
     key = case Curses.getch
        when Curses::Key::UP then
          :up
        when Curses::Key::DOWN then
          :down
        when Curses::Key::RIGHT then
          :right
        when Curses::Key::LEFT then
          :left
        else
          nil
        end
      input_buffer <<  key unless key.nil?
      sleep(0.2)
    end
  end
   t.abort_on_exception = true
   t
end

def init_curses
  Curses.noecho # do not show typed keys
  Curses.init_screen
  Curses.stdscr.keypad(true) # enable arrow keys
end

def game_loop(input_buffer)
  game = Game.new(11, 7)
  t = Thread.new do
    loop do
      game.update(input_buffer.shift)
      game.display
      sleep(0.1)
    end
  end
  t.abort_on_exception = true
  t
end

def run
  begin
    init_curses
    input_buffer = RingBuffer.new(5)
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
