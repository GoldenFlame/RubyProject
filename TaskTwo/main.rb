require 'yaml'
require 'rubygems'  
require 'active_record' 
files = %w{entity city item monster avatar yaml_manage ui fight shop world avatar_item}
files.each{|x| require File.join(File.dirname(__FILE__), "lib/#{x}")}

ActiveRecord::Base.establish_connection(  
:adapter => "postgresql",  
:host => "localhost",  
:database => "rpg",
:username => "postgres",
:password => "master"  
)  





=begin
Avatar_item.create(:user => 8,
      :item => 18,
      :amount => 2)  

Avatar.create(:name => "nusa",
      :password => "nusa", 
      :avatar_class => 0,
      :level => 1,
      :exp => 0,
      :current_city => 0,
      :gold => 100,
      :base_dmg_min => 0,
      :base_dmg_max => 0,
      :max_hp => 10,
      :hp => 10,
      :max_mana => 10,
      :mana => 10)

      City.create(:name => "Ellion",
      :shop => "Run Down Shop",
      :inn => "Wild Legs Inn",
      :fight_area_nr => 1)
      
      Item.create(:name => "Wooden staff",
      :item_class => "staff",
      :level => 1,
      :damage_min => 10,
      :damage_max => 30,
      :price => 10)
      Item.create(:name => "Simple staff",
      :item_class => "staff",
      :level => 5,
      :damage_min => 40,
      :damage_max => 70,
      :price => 100)
      Item.create(:name => "Warriors staff",
      :item_class => "staff",
      :level => 10,
      :damage_min => 60,
      :damage_max => 120,
      :price => 500)
      Item.create(:name => "Wooden sword",
      :item_class => "sword",
      :level => 1,
      :damage_min => 10,
      :damage_max => 20,
      :price => 10)
      Item.create(:name => "Simple sword",
      :item_class => "sword",
      :level => 5,
      :damage_min => 45,
      :damage_max => 60,
      :price => 100)
      Item.create(:name => "Broad sword",
      :item_class => "sword",
      :level => 10,
      :damage_min => 70,
      :damage_max => 100,
      :price => 500)

      Item.create(:name => "Practice bow",
      :item_class => "bow",
      :level => 1,
      :damage_min => 10,
      :damage_max => 50,
      :price => 10)
      Item.create(:name => "Simple bow",
      :item_class => "bow",
      :level => 5,
      :damage_min => 20,
      :damage_max => 60,
      :price => 100)
      Item.create(:name => "Hunter bow",
      :item_class => "bow",
      :level => 10,
      :damage_min => 40,
      :damage_max => 100,
      :price => 500)
      Item.create(:name => "Leather armor",
      :item_class => "armor",
      :level => 1,
      :armor => 5,
      :price => 10)
      Item.create(:name => "Chainmail armor",
      :item_class => "armor",
      :level => 5,
      :armor => 15,
      :price => 100)
      Item.create(:name => "Plate armor",
      :item_class => "armor",
      :level => 10,
      :armor => 30,
      :price => 500)
  
      Monster.create(:name => "Blob",
      :level => 1,
      :base_dmg_min => 5,
      :base_dmg_max => 8,
      :max_hp => 300,
      :hp => 300,
      :exp_bonus => 20,
      :gold_max => 120)
      
      Monster.create(:name => "Sin",
      :level => 1,
      :base_dmg_min => 10,
      :base_dmg_max => 30,
      :max_hp => 75,
      :hp => 75,
      :exp_bonus => 30,
      :gold_max => 100)
=end   
=begin
class Sin < ActiveRecord::Base  
  
end

class It < ActiveRecord::Base
  
end

class User_it < ActiveRecord::Base
  
end
  

#It.create(:name => 'item1', :damage => 10)
#It.create(:name => 'item2', :damage => 15)

#Sin.create(:name => 'New', :cities => 1, :c1 => "Ellion", :exp_rate => 1)
    item1 = It.find_by_name('item1')
    item2 = It.find_by_name('item2')
    world = Sin.first
    
    pack = User_it.create(:user => world.id, :amount => 1, :item_id => item1.id)
    pack.user = world.id
    pack.item = item1.id
    
    pack.save
    
    world.pack = item1
    #world.pack.push(item2)
    puts world.name
    world.name = 'Older'
    puts world.name
    #world.update_attribute :name, 'Old'
    world.save
=end

game = World.new

game.main_menu