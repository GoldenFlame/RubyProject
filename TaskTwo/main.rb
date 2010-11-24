require 'rubygems'  
require 'active_record' 
files = %w{city item monster avatar yaml_manage ui shop world avatar_item shop_item fight_area}
files.each{|x| require File.join(File.dirname(__FILE__), "lib/#{x}")}

ActiveRecord::Base.establish_connection(  
:adapter => "postgresql",  
:host => "localhost",  
:database => "rpg",
:username => "postgres",
:password => "master"  
)  


game = World.new
game.main_menu