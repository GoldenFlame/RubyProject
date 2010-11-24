class World
  attr_reader :interface, :shop_inst, :citys, :items, :exitcmd
  def initialize 
    @exitcmd = false
    world = YamlManage.load_file("data/world.yml")
    cities_number = world[:cities]
    @citys = (1..cities_number.to_i).collect{|x| City.new("data/city/#{world[x.to_s.to_sym]}.yml")}
    @interface = Ui.new(self)
    @items = load_items
    @shop_inst = Shop.new(@interface, @items)
  end
  
  def start_fight(avatar,enemy)
    monster = Monster.new("data/monster/#{enemy}.yml")
    defeat = false
    while(!defeat)
      @interface.clear_console
      @interface.battle_info(avatar, monster)
      @interface.fight_menu(avatar, monster)
      monster.attack(avatar)
      defeat = check_fight_end(avatar,monster)
      avatar.save
    end
  end
  
  def check_fight_end(avatar, monster)
    defeat = false
    if(monster.hp <= 0)
      defeat = true
      player_prize(avatar, monster)
    elsif(avatar.hp <= 0)
      defeat = true
      player_penalty(avatar, monster)
    end
    return defeat
  end
  
  def player_prize(avatar, enemy)
    @interface.winner_msg(avatar)
    avatar.exp += enemy.exp_bonus
    avatar.gold += Random.new.rand(0..enemy.gold_max)
  end
  
  def player_penalty(avatar,enemy)
    @interface.looser_msg(avatar)
    avatar.gold -= Random.new.rand(0..enemy.gold_max) / 10
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
