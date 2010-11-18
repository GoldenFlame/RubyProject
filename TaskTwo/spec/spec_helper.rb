require 'simplecov'
require 'rspec'
require 'blueprints'
require 'active_record'
SimpleCov.start


ActiveRecord::Base.establish_connection(  
:adapter => "postgresql",  
:host => "localhost",  
:database => "rpg_spec",
:username => "postgres",
:password => "master"  
)  
Blueprints.enable
require File.dirname(__FILE__) + '/../lib/ui.rb'
require File.dirname(__FILE__) + '/../lib/world.rb'
require File.dirname(__FILE__) + '/../lib/fight.rb'
require File.dirname(__FILE__) + '/../lib/shop.rb'
require File.dirname(__FILE__) + '/../lib/yaml_manage.rb'
require File.dirname(__FILE__) + '/../lib/item.rb'
require File.dirname(__FILE__) + '/../lib/monster.rb'
require File.dirname(__FILE__) + '/../lib/city.rb'
require File.dirname(__FILE__) + '/../lib/avatar.rb'
require File.dirname(__FILE__) + '/../lib/avatar_item.rb'
require File.dirname(__FILE__) + '/../lib/fight_area.rb'
require File.dirname(__FILE__) + '/../matchers/be_readable.rb'
require File.dirname(__FILE__) + '/../matchers/be_updated.rb'



