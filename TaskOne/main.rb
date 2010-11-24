require 'yaml'
files = %w{entity city item monster avatar yaml_manage ui shop world}
files.each{|x| require File.join(File.dirname(__FILE__), "lib/#{x}")}
  
game = World.new
game.main_menu