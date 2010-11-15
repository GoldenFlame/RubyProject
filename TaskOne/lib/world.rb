class World
  attr_reader :fight, :interface, :shop_inst, :citys, :items, :exitcmd
  def initialize 
    @exitcmd = false
    world = YamlManage.load_file("data/world.yml")
    cities_number = world[:cities]
    @citys = (1..cities_number.to_i).collect{|x| City.new("data/city/#{world[x.to_s.to_sym]}.yml")}
    @interface = Ui.new(self)
    @fight = Fight.new(@interface)
    @items = load_items
    @shop_inst = Shop.new(@interface, @items)
  end
  
  def load_items
    Dir.glob("data/item/*").collect{|x| Item.new(x)}
  end
  
  def exit
    @exitcmd = true
  end  
  
  def main_menu
    avatar = nil
    while(avatar == nil) do
      avatar = @interface.login()
    end
    while(true)
      if(avatar.avatar_class == 0)
        @interface.choose_class(avatar)
      else 
        @interface.clear_console
        avatar.check_lvlup 
        @interface.go_to_world(avatar)
        avatar.save
      end
      break if(@exitcmd) 
    end
  end
  

  
#---------  
  def class_warrior(avatar)
    avatar.avatar_class = 1
    avatar.base_dmg_min = 20
    avatar.base_dmg_max = 30
    avatar.max_hp = 100
    avatar.hp = 100
    avatar.max_mana = 10
    avatar.mana = 10
    avatar.save
  end

  def class_archer(avatar)
    avatar.avatar_class = 2
    avatar.base_dmg_min = 10
    avatar.base_dmg_max = 50
    avatar.max_hp = 75
    avatar.hp = 75
    avatar.max_mana = 30
    avatar.mana = 30
    avatar.save
  end
  
  def class_mage(avatar)
    avatar.avatar_class = 3
    avatar.base_dmg_min = 10
    avatar.base_dmg_max = 20
    avatar.max_hp = 50
    avatar.hp = 50
    avatar.max_mana = 100
    avatar.mana = 100
    avatar.save
  end
#---------    

  def rest(avatar)
    avatar.hp = avatar.max_hp
    avatar.mana = avatar.max_mana
  end

#---------
  def find_arena_monster(city)
    if(city.fight_area_nr !=0)
      area = Random.new.rand(1..city.fight_area_nr)
      if(city.fight_area[area.to_s.to_sym][:monsters].size != 0)
        city.fight_area[area.to_s.to_sym][:monsters][Random.new.rand(0..city.fight_area[area.to_s.to_sym][:monsters].size-1)]
      end
    end
  end   
  
#---------   
  
  
  def reg(name,pass)
    YamlManage.create_user(name,pass)
  end
  
  def logs(name)
    Avatar.new("data/user/#{name.chomp}.yml") if(File.exist? "data/user/#{name.chomp}.yml")
  end
    
#---------  
  def find_item(item_name)
    item_return = nil
    @items.each do |x|
      if(x.name == item_name)
        item_return = x
        break
      end
    end
    return item_return
  end
  
  
 
end
