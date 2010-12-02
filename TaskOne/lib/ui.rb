require 'rbconfig'
class Ui
  def initialize(world)
    @world = world
  end
#------Interface control  
  def read_ch
    require "Win32API"
    Win32API.new("crtdll", "_getch", [], "L").Call
  end

  def clear_console
    if(Config::CONFIG['host_os'] =~ /mswin|mingw/)
      system('cls')
    else
      system('clear')
    end
  end
  
#------Login menu
  def login
    clear_console
    puts "Welcome"
    puts "1.Register"
    puts "2.Login"
    case read_ch-48
    when 1 then reg
    when 2 then logs
    end
  end
  
  def reg
    registered = false
    while(!registered)
      puts 'Enter your nickname'
      name = gets
      registered = true if(!File.exist? "data/user/#{name.chomp}.yml") 
      puts 'Enter your password'
      pass = gets
      @world.reg(name,pass)
      if registered
        puts 'You successfully created you account. You can log in now.'
      else
        puts "This name is already taken."
      end
    end
  end
  
  def logs
    logged_in = false
    while(!logged_in)
      puts 'Enter your nickname'
      name = gets
      puts 'Enter your password'
      pass = gets
      avatar = @world.logs(name)
      if(avatar != nil)
        if(avatar.password == pass.chomp)
          logged_in = true
          puts 'You successfully logged in.'
        end
      else
        puts 'Avatar does not exist or you entered incorrect password'
        avatar = nil
      end
    end
    return avatar
  end
#------Stats
  def show_stats(avatar)
    clear_console
    puts "Name: #{avatar.name}"
    puts "Class: #{avatar.avatar_class}"
    puts "Level: #{avatar.level}"
    puts "Experience: #{avatar.exp}/#{avatar.experience_for_level}"
    puts "HP: #{avatar.hp}/#{avatar.max_hp}"
    puts "Mana: #{avatar.mana}/#{avatar.max_mana}"
    puts "Base damage: #{avatar.base_dmg_min}/#{avatar.base_dmg_max}"
    puts "1. View equiped items."
    puts "2. Go back"
    case read_ch-48
    when 1 then view_equipment(avatar)
    when 2 then 
    else show_stats(avatar)
    end
  end
#------Inventory  
  def view_equipment(avatar)
    clear_console
    weapon = false
    armor = false
    if(avatar.eq_weapon != nil)
      weapon = true
      puts "Weapon:"
      puts "Name: #{avatar.eq_weapon.name}"
      puts "Class: #{avatar.eq_weapon.item_class}"
      puts "Level requirement: #{avatar.eq_weapon.level}"
      puts "Damage #{avatar.eq_weapon.damage_min}/#{avatar.eq_weapon.damage_max}"
    else
      puts "You have no weapon equiped."
    end
    if(avatar.eq_armor != nil)
      armor = true
      puts ""
      puts "---"
      puts ""
      puts "Armor:"
      puts "Name: #{avatar.eq_armor.name}"
      puts "Class: #{avatar.eq_armor.item_class}"
      puts "Level requirement: #{avatar.eq_armor.level}"
      puts "Armor: #{avatar.eq_armor.armor}"
    else
      puts "You have no armor equiped."
    end
    if(weapon && armor)
      puts "1.Disequip weapon"
      puts "2.Disequip armor"
      puts "3.Leave"
      case read_ch-48
      when 1 then avatar.disequip(avatar.eq_weapon)
      when 2 then avatar.disequip(avatar.eq_armor)
      when 3 then show_stats(avatar)
      else view_equipment(avatar)
      end
    elsif(weapon && !armor)
      puts "1.Disequip weapon"
      puts "2.Leave"
      case read_ch-48
      when 1 then avatar.disequip(avatar.eq_weapon)
      when 2 then show_stats(avatar)
      else view_equipment(avatar)
      end
    elsif(!weapon && armor)
      puts "1.Disequip armor"
      puts "2.Leave"
      case read_ch-48
      when 1 then avatar.disequip(avatar.eq_armor)
      when 2 then show_stats(avatar)
      else view_equipment(avatar)
      end
    else
      puts "Press any key to continue"
      read_ch
      show_stats(avatar) 
    end
  end
  
  def show_inventory(avatar,call)
    clear_console
    if(avatar.backpack.class == Array)
      if(avatar.backpack.size != 0)
        avatar.backpack.each_with_index{|x,y| puts "#{y+1}. #{x.name}"}
        c = -1
        until (avatar.backpack.length>= c && c >= 0)
          c = gets
          c = c.chomp.to_i
        end
          inventory_item_view(avatar, avatar.backpack[c-1], call)
      else
        puts "Your inventory is empty."
      end
    end
  end
  
  def inventory_item_view(avatar, item, call)
    clear_console
    puts "Name: #{item.name}"
    puts "Class: #{item.item_class}"
    puts "Level requirement: #{item.level}"
    if(item.item_class == "weapon")
      puts "Damage #{item.damage_min}/#{item.damage_max}"
    elsif(item.item_class == "armor")
      puts "Armor: #{item.armor}"
    end
    if(call == 1)
      puts "1.Equip"
      puts "2.Leave"
      case read_ch-48
      when 1 then avatar.equip(item)
      when 2 then 
      else show_status(avatar)
      end
    elsif(call == 2)
      puts "1.Sell for #{item.price/2}"
      puts "2.Leave"
      case read_ch-48
      when 1 then avatar.sell_item(item)
      when 2 then 
      else show_status(avatar)
      end
    end
  end
#------Main menu  
  def go_to_world(avatar)
    puts "1. Go to arena."
    puts "2. Go to the wilds."
    puts "3. Go to the shop."
    puts "4. Go to the inn."
    puts "5. View your stats."
    puts "6. View your inventory."
    puts "7. Exit game"
    case read_ch-48
    when 1 then arena(avatar)
    when 2 then wilds(avatar, @world.citys[avatar.current_city])
    when 3 then shop(avatar, @world.citys[avatar.current_city].shop)
    when 4 then inn(avatar, @world.citys[avatar.current_city].inn)
    when 5 then show_stats(avatar)
    when 6 then show_inventory(avatar,1)
    when 7 then @world.exit
    end
  end
  
  def inn(avatar,name)
    clear_console
    puts "Welcome to #{name}"
    puts "1.Rest and regain your strength."
    puts "2.Leave."
    case read_ch-48
    when 1 then @world.rest(avatar)
    when 2 then go_to_world(avatar)
    else inn(avatar, name)
    end
  end
  
  def shop(avatar,name)
    clear_console
    puts "Welcome to #{name}"
    puts "1.Buy item"
    puts "2.Sell item"
    puts "3.Leave"
    case read_ch-48
    when 1 then buy_shop(avatar)
    when 2 then sell_shop(avatar)
    when 3 then go_to_world(avatar)
    else shop(avatar,name)
    end
  end
  
  def buy_shop(avatar)
    clear_console
    puts "1. Buy sword."
    puts "2. Buy bow."
    puts "3. Buy magic staff."
    puts "4. Buy armor"
    puts "5. Go back."
    case read_ch-48
    when 1 then @world.item(avatar, "sword")
    when 2 then @world.item(avatar, "bow")
    when 3 then @world.item(avatar, "staff")
    when 4 then @world.item(avatar, "armor")
    when 5 then shop(avatar,name)
    else buy_shop(avatar)
    end
  end
  
  def sell_shop(avatar)
    clear_console
    puts "Select item to sell:"
    show_inventory(avatar,2)
    
  end
  
  def wilds(avatar,city)
    clear_console
    if(avatar.hp>0)
      if(city.fight_area_nr !=0)
        puts "Go to:"
        (1..city.fight_area_nr).collect{|x| puts x.to_s+". "+city.fight_area[x.to_s.to_sym][:name]}
        c = read_ch-48
        go_to_area(avatar,city.fight_area[c.to_s.to_sym])    
      else
        puts "There are no wild areas which you can visit now."
      end
    else
      puts "You need to go to inn to rest."
       puts "Press any key to continue."
       read_ch
    end
    
  end
  
  def arena(avatar)
    clear_console
    if(avatar.hp>0)
      puts "Welcome to the arena."
      puts "1.Fight random monster."
      puts "2.Go back."
      case read_ch-48
      when 1 then @world.start_fight(avatar, @world.find_arena_monster(@world.citys[avatar.current_city]))
      when 2 then go_to_world(avatar)
      else arena(avatar)
      end
    else
      puts "You need to go to inn to rest."
      puts "Press any key to continue."
      read_ch
    end
  end
  
  def go_to_area(avatar,area)
    if(area[:monsters].size != 0)
      monster = area[:monsters][Random.new.rand(0..area[:monsters].size-1)]
      @world.fight.fight(avatar, monster)
    end
  end
  
#------Shop menu  
  def item_view(avatar,item)
    clear_console
    puts item.name
    puts "Level requirement: #{item.level}"
    if(item.item_class == "weapon")
      puts "Damage #{item.damage_min}/#{item.damage_max}"
    elsif(item.item_class == "armor")
      puts "Armor: #{item.armor}"
    end
    puts "Price: #{item.price}"
    if(avatar.gold >= item.price)
      puts "1. Buy."
    else 
      puts "You do not have enough money."
    end
    puts "2. Go back."
    c = read_ch-48
    if(avatar.gold>=item.price)
      case c
      when 1 then avatar.buy_item(item)
      when 2 then @world.item(avatar, item.item_class)
      else item_view(avatar, item, @interface.read_ch-48)
      end
    else
      case c
      when 2 then @world.item(avatar,item.item_class)
      else item_view(avatar, item, @interface.read_ch-48)
      end
    end
  end
  
  def item(item_list)
    clear_console
    item_list.each_with_index{|x,y| puts "#{y+1}. #{x.name}"}
    puts "#{item_list.size + 1}. Leave shop."
    c = read_ch-48
    until (item_list.size+1>= c && c >= 0)
      c = read_ch-48
    end
    c
  end

#------Fight menu  
  
  def winner_msg(avatar)
    puts "You have WON the battle!"
    puts "Press any key to return to town."
    puts "Don`t forget to visit inn to rest and heal your wounds."
    read_ch
  end
  
  def looser_msg(avatar)
    puts "You have LOST the battle."
    puts "Press any key to return to town."
    puts "Don`t forget to visit inn to rest and heal your wounds."
    read_ch
  end
  
  def battle_info(avatar, enemy)
    puts "You are finghting #{enemy.name}"
    puts "Your stats:"
    puts "HP: #{avatar.hp}/#{avatar.max_hp}"
    puts "Mana: #{avatar.mana}/#{avatar.max_mana}"
    puts "Base damage: #{avatar.base_dmg_min}/#{avatar.base_dmg_max}"
    puts "----"
    puts "#{enemy.name} stats:"
    puts "HP: #{enemy.hp}/#{enemy.max_hp}"
    puts "Base damage: #{enemy.base_dmg_min}/#{enemy.base_dmg_max}"
  end
  
  def fight_menu(avatar,enemy)
    puts "1.Basic attack"
    puts "2.Skill attack"
    puts "3.Use item"
    puts "4.Run away"
    case read_ch-48
    when 1 then avatar.attack(enemy)
    when 2 then avatar.skill_attack(enemy)
    when 3 then avatar.heal
    else fight_menu(avatar, enemy)
    end
  end
#------Class menu  
  def choose_class(avatar)
    clear_console
    puts 'Choose your avataracters class'
    puts '1. Warrior(Melee fighter)'
    puts '2. Archer(Ranged fighter)'
    puts '3. Mage(Magic fighter)'
    case read_ch-48
    when 1 then @world.class_warrior(avatar)
    when 2 then @world.class_archer(avatar)
    when 3 then @world.class_mage(avatar)
    else choose_class(avatar)
    end
  end
end
