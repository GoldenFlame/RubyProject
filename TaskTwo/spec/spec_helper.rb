require 'simplecov'
require 'rspec'
require 'blueprints'
require 'active_record'
SimpleCov.start


ActiveRecord::Base.establish_connection(  
:adapter => "postgresql",  
:host => "localhost",  
:database => "rpg_test",
:username => "postgres",
:password => "master"  
)  
Blueprints.enable
require File.dirname(__FILE__) + '/../lib/ui.rb'
require File.dirname(__FILE__) + '/../lib/world.rb'
require File.dirname(__FILE__) + '/../lib/shop.rb'
require File.dirname(__FILE__) + '/../lib/shop_item.rb'
require File.dirname(__FILE__) + '/../lib/item.rb'
require File.dirname(__FILE__) + '/../lib/monster.rb'
require File.dirname(__FILE__) + '/../lib/city.rb'
require File.dirname(__FILE__) + '/../lib/avatar.rb'
require File.dirname(__FILE__) + '/../lib/avatar_item.rb'
require File.dirname(__FILE__) + '/../lib/fight_area.rb'
require File.dirname(__FILE__) + '/../matchers/have_hash_values.rb'
require File.dirname(__FILE__) + '/../matchers/be_loaded_with.rb'

RSpec.configure do |config|  
  config.include(Matchers)  
end



