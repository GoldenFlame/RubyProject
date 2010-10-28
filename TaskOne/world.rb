require File.join(File.dirname(__FILE__), 'yaml_manage.rb')
require File.join(File.dirname(__FILE__), 'ui.rb')
require File.join(File.dirname(__FILE__), 'fight.rb')
require File.join(File.dirname(__FILE__), 'shop.rb')

class World
  attr_accessor :fight, :interface, :shop_inst
  @city
  @exitcmd
  @fight
  def initialize 
    @exitcmd = false
    world = YamlManage.load_file("data/world.yml")
    cities_number = world[:cities]
    @city = (1..cities_number.to_i).collect{|x| YamlManage.load_file("data/city/#{world[x.to_s.to_sym]}.yml")}
    @interface = Ui.new(self)
    @fight = Fight.new(@interface)
    @shop_inst = Shop.new(@interface)
  end
  
  def exit
    @exitcmd = true
  end  
  
  def main_menu
    char = nil
    while(char == nil) do
      char = @interface.login()
    end
    res = nil
    while(true)
      if(char[:class] == 0)
        res = @interface.choose_class(char)
      else 
        @interface.clear_console
        res = check_lvlup(char), @interface.go_to_world(char)
      end
      break if(@exitcmd) 
    end
    return res
  end
  
  def autosave(char)
    YamlManage.save_char(char)
  end
  
  def check_lvlup(char)
    case char[:exp]
    when 50 then char[:level] = 2
    when 100 then char[:level] = 3
    when 200 then char[:level] = 4
    when 400 then char[:level] = 5
    when 800 then char[:level] = 6
    when 1600 then char[:level] = 7
    when 2400 then char[:level] = 8
    when 4000 then char[:level] = 9
    when 5800 then char[:level] = 10
    when 8000 then char[:level] = 11
    when 10500 then char[:level] = 12
    when 15000 then char[:level] = 13
    when 21000 then char[:level] = 14
    when 30000 then char[:level] = 15
    when 43000 then char[:level] = 16
    when 58000 then char[:level] = 17
    when 70000 then char[:level] = 18
    when 95000 then char[:level] = 19
    when 120000 then char[:level] = 20
    end
  end
#---------  
  def class_warrior(char)
    char[:class] = 1
    char[:base_dmg_min] = 20
    char[:base_dmg_max] = 30
    char[:max_hp] = 100
    char[:hp] = 100
    char[:max_mana] = 10
    char[:mana] = 10
    char[:backpack] = {:sword => 'Wooden sword'}
    YamlManage.save_char(char)
  end

  def class_archer(char)
    char[:class] = 2
    char[:base_dmg_min] = 10
    char[:base_dmg_max] = 50
    char[:max_hp] = 75
    char[:hp] = 75
    char[:max_mana] = 30
    char[:mana] = 30
    char[:backpack] = {:bow => 'Practice bow'}
    YamlManage.save_char(char)
  end
  
  def class_mage(char)
    char[:class] = 3
    char[:base_dmg_min] = 10
    char[:base_dmg_max] = 20
    char[:max_hp] = 50
    char[:hp] = 50
    char[:max_mana] = 100
    char[:mana] = 100
    char[:backpack] = {:staff => 'Wooden staff'}
    YamlManage.save_char(char)
  end
#---------    

  def rest(char)
    char[:hp] = char[:max_hp]
    char[:mana] = char[:max_mana]
  end

#---------
  def find_arena_monster(city)
    if(city[:fight_area].to_i !=0)
      area = "f#{Random.new.rand(1..city[:fight_area].to_i)}monsters"
      if(city[area.to_sym].size != 0)
        city[area.to_sym][Random.new.rand(0..city[area.to_sym].size-1)]
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
    YamlManage.create_char(name,pass)
  end
  
  def logs(name)
    YamlManage.load_file("data/user/#{name.chomp}.yml") if(File.exist? "data/user/#{name.chomp}.yml")
  end
    
  
  def find_item(arg, item_name)
    item_return = nil
    items = Dir.glob("data/item/*").collect{|x| YamlManage.load_file(x)}
    items.each do |x|
      if(x[:name] == item_name)
        item_return = x
      end
    end
    return item_return
  end
  
  def show_inventory(char, c, sw, bw, st)
    case c
    when 1 then @interface.item_menu_inventory(char, :sword) if(sw != 0)
    when 2 then @interface.item_menu_inventory(char, :bow) if(bw != 0)
    when 3 then @interface.item_menu_inventory(char, :staff) if(st != 0)
    when 4 then @interface.go_to_world(char)
    else show_inventory(char, @interface.read_ch-48, sw, bw, st)
    end
  end
    
  def go_to_world(char,c)
    case c
    when 1 then @interface.arena(char)
    when 2 then @interface.wilds(char, @city[char[:current_city]])
    when 3 then @interface.shop(char, @city[char[:current_city]][:shop])
    when 4 then @interface.inn(char, @city[char[:current_city]][:inn])
    when 5 then @interface.show_stats(char)
    when 6 then @interface.show_inventory(char)
    when 7 then exit
    end
  end
  
  def inn(char,c)
    case c
    when 1 then rest(char)
    when 2 then @interface.go_to_world(char)
    else inn(char, @interface.read_ch-48)
    end
  end
  
  def shop(char,c)
    case c
    when 1 then @shop_inst.item(char, "sword")
    when 2 then @shop_inst.item(char, "bow")
    when 3 then @shop_inst.item(char, "staff")
    when 4 then @interface.go_to_world(char)
    else shop(char, @interface.read_ch-48)
    end
  end
  
  def wilds(char,c,city)
    area = "fight_#{c.to_s}"
    @interface.go_to_area(char,city[area.to_sym])
  end
  
  def arena(char,c)
    case c
    when 1 then @fight.fight(char, find_arena_monster(@city[char[:current_city]]))
    when 2 then @interface.go_to_world(char)
    else arena(char,@interface.read_ch-48)
    end
  end
  
  def fight_menu(char, enemy, c)
    case c
    when 1 then @fight.attack(char, enemy)
    when 2 then @fight.skill(char, enemy)
    when 3 then @fight.use_item(char)
    else fight_menu(char, enemy, @interface.read_ch-48)
    end
  end
  
  def choose_class(char,c)
    case c
    when 1 then class_warrior(char)
    when 2 then class_archer(char)
    when 3 then class_mage(char)
    else choose_class(char, @interface.read_ch-48)
    end
  end
 
end
