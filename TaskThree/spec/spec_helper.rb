require 'simplecov'
require 'blueprints'
require 'active_record'
require File.expand_path("../../config/environment", __FILE__)
SimpleCov.start

ActiveRecord::Base.establish_connection(  
:adapter => "postgresql",  
:host => "localhost",  
:database => "rpg_test",
:username => "postgres",
:password => "master"  
)  
Blueprints.enable
require 'rspec/rails'

require File.dirname(__FILE__) + '/../config/application.rb'

require File.dirname(__FILE__) + '/../matchers/have_hash_values.rb'
require File.dirname(__FILE__) + '/../matchers/be_loaded_with.rb'


RSpec.configure do |config|  
  config.include(Matchers)  
end

