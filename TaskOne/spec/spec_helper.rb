require 'simplecov'
SimpleCov.start
require File.dirname(__FILE__) + '/../lib/ui.rb'
require File.dirname(__FILE__) + '/../lib/world.rb'
require File.dirname(__FILE__) + '/../lib/shop.rb'
require File.dirname(__FILE__) + '/../lib/yaml_manage.rb'
require File.dirname(__FILE__) + '/../lib/entity.rb'
require File.dirname(__FILE__) + '/../lib/item.rb'
require File.dirname(__FILE__) + '/../lib/monster.rb'
require File.dirname(__FILE__) + '/../lib/city.rb'
require File.dirname(__FILE__) + '/../lib/avatar.rb'
require File.dirname(__FILE__) + '/../matchers/have_hash_values.rb'
require File.dirname(__FILE__) + '/../matchers/be_loaded_with.rb'

RSpec.configure do |config|  
  config.include(Matchers)  
end



