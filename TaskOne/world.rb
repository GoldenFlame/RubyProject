class World
  attr_accessor :fight, :interface, :shop_inst
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
    res = nil
    while(true)
      if(avatar.avatar_class == 0)
        res = @interface.choose_class(avatar)
      else 
        @interface.clear_console
        res = check_lvlup(avatar), @interface.go_to_world(avatar)
      end
      break if(@exitcmd) 
    end
    return res
  end
  
  def autosave(avatar)
    #YamlManage.save_avatar(avatar)
  end
  
  def check_lvlup(avatar)
=begin
    case avatar.exp]
    when 50 then avatar.level] = 2
    when 100 then avatar.level] = 3
    when 200 then avatar.level] = 4
    when 400 then avatar.level] = 5
    when 800 then avatar.level] = 6
    when 1600 then avatar.level] = 7
    when 2400 then avatar.level] = 8
    when 4000 then avatar.level] = 9
    when 5800 then avatar.level] = 10
    when 8000 then avatar.level] = 11
    when 10500 then avatar.level] = 12
    when 15000 then avatar.level] = 13
    when 21000 then avatar.level] = 14
    when 30000 then avatar.level] = 15
    when 43000 then avatar.level] = 16
    when 58000 then avatar.level] = 17
    when 70000 then avatar.level] = 18
    when 95000 then avatar.level] = 19
    when 120000 then avatar.level] = 20
    end
=end
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
  def login(c)
    case c
    when 1 then @interface.reg
    when 2 then @interface.logs
    end
  end
  
  def reg(name,pass)
    YamlManage.create_user(name,pass)
  end
  
  def logs(name)
    Avatar.new("data/user/#{name.chomp}.yml") if(File.exist? "data/user/#{name.chomp}.yml")
  end
    
  
  def find_item(item_name)
    item_return = nil
    @items.each do |x|
      if(x.name == item_name)
        item_return = x
      end
    end
    return item_return
  end
  
  def show_inventory(avatar, c, sw, bw, st)
    case c
    when 1 then @interface.item_menu_inventory(avatar, :sword) if(sw != 0)
    when 2 then @interface.item_menu_inventory(avatar, :bow) if(bw != 0)
    when 3 then @interface.item_menu_inventory(avatar, :staff) if(st != 0)
    when 4 then @interface.go_to_world(avatar)
    else show_inventory(avatar, @interface.read_ch-48, sw, bw, st)
    end
  end
    
  def go_to_world(avatar,c)
    case c
    when 1 then @interface.arena(avatar)
    when 2 then @interface.wilds(avatar, @citys[avatar.current_city])
    when 3 then @interface.shop(avatar, @citys[avatar.current_city].shop)
    when 4 then @interface.inn(avatar, @citys[avatar.current_city].inn)
    when 5 then @interface.show_stats(avatar)
    when 6 then @interface.show_inventory(avatar)
    when 7 then exit
    end
  end
  
  def inn(avatar,c)
    case c
    when 1 then rest(avatar)
    when 2 then @interface.go_to_world(avatar)
    else inn(avatar, @interface.read_ch-48)
    end
  end
  
  def shop(avatar,c)
    case c
    when 1 then @shop_inst.item(avatar, "sword")
    when 2 then @shop_inst.item(avatar, "bow")
    when 3 then @shop_inst.item(avatar, "staff")
    when 4 then @interface.go_to_world(avatar)
    else shop(avatar, @interface.read_ch-48)
    end
  end
  
  def wilds(avatar,c,city)
    @interface.go_to_area(avatar,city.fight_area[c.to_s.to_sym])
  end
  
  def arena(avatar,c)
    case c
    when 1 then @fight.fight(avatar, find_arena_monster(@citys[avatar.current_city]))
    when 2 then @interface.go_to_world(avatar)
    else arena(avatar,@interface.read_ch-48)
    end
  end
  
  def fight_menu(avatar, enemy, c)
    case c
    when 1 then @fight.attack(avatar, enemy)
    when 2 then @fight.skill(avatar, enemy)
    when 3 then @fight.use_item(avatar)
    else fight_menu(avatar, enemy, @interface.read_ch-48)
    end
  end
  
  def choose_class(avatar,c)
    case c
    when 1 then class_warrior(avatar)
    when 2 then class_archer(avatar)
    when 3 then class_mage(avatar)
    else choose_class(avatar, @interface.read_ch-48)
    end
  end
 
end
