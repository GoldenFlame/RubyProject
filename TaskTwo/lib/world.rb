class World
  attr_reader :fight, :interface, :shop_inst, :citys, :items, :exitcmd
  def initialize 
    @exitcmd = false
    @citys = City.all
    @interface = Ui.new(self)
    
  end
  
  def start_fight(avatar,monster)
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
  
  
  def exit
    @exitcmd = true
  end  
  
  def main_menu
    avatar = nil
    while(avatar == nil) do
      avatar = @interface.login()
    end
    avatar.backpack_init
    avatar.equipment_init
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
    if(city.fight_areas.size !=0)
      area = city.fight_areas[Random.new.rand(0..city.fight_areas.size-1)]
      monsters = area.monsters
      if(monsters.size != 0)
        monsters[Random.new.rand(0..monsters.size-1)]
      end
    end
  end   
  
#---------   
  
  
  def reg(name,pass)
    city = City.find_by_name("Ellion").id
    Avatar.create(:name => name.chomp,
      :password => pass.chomp, 
      :avatar_class => 0,
      :level => 1,
      :exp => 0,
      :city_id => city,
      :gold => 100,
      :base_dmg_min => 0,
      :base_dmg_max => 0,
      :max_hp => 10,
      :hp => 10,
      :max_mana => 10,
      :mana => 10,
      )
  end
  
  def logs(name)
    Avatar.find_by_name(name.chomp)
  end
    
#--------- 
 
end
