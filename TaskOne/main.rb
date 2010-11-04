require 'rubygems'
require 'yaml'

require File.join(File.dirname(__FILE__), 'entity.rb')
require File.join(File.dirname(__FILE__), 'city.rb')
require File.join(File.dirname(__FILE__), 'item.rb')
require File.join(File.dirname(__FILE__), 'monster.rb')
require File.join(File.dirname(__FILE__), 'avatar.rb')
require File.join(File.dirname(__FILE__), 'yaml_manage.rb')
require File.join(File.dirname(__FILE__), 'ui.rb')
require File.join(File.dirname(__FILE__), 'fight.rb')
require File.join(File.dirname(__FILE__), 'shop.rb')
require File.join(File.dirname(__FILE__), 'city.rb')
require File.join(File.dirname(__FILE__), 'world.rb')

game = World.new
game.main_menu