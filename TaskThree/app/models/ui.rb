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
      #system('cls')
    else
      system('clear')
    end
  end
  
#------Login menu
  def login
    avatar = @world.shop_inst
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
        if(avatar.password.chomp == pass.chomp)
          logged_in = true
          puts logged_in
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
    puts "Welcome to #{avatar.city.name}"
    puts "1. Go to arena."
    puts "2. Go to the wilds."
    puts "3. Go to the shop."
    puts "4. Go to the inn."
    puts "5. Travel"
    puts "6. View your stats."
    puts "7. View your inventory."
    puts "8. Exit game"
    case read_ch-48
    when 1 then arena(avatar)
    when 2 then wilds(avatar)
    when 3 then shop(avatar)
    when 4 then inn(avatar)
    when 5 then city_list(avatar)
    when 6 then show_stats(avatar)
    when 7 then show_inventory(avatar,1)
    when 8 then @world.exit
    end
  end
  
  def city_list(avatar)
    City.all.each_with_index{|x,y| puts "#{y+1}. #{x.name}"}
    c = -1
    until (City.all.size>= c && c >= 0)
      c = read_ch-49
    end
    avatar.travel(City.all[c])
  end
  
  def inn(avatar)
    clear_console
    puts "Welcome to #{avatar.city.inn}"
    puts "1.Rest and regain your strength."
    puts "2.Leave."
    case read_ch-48
    when 1 then @world.rest(avatar)
    when 2 then go_to_world(avatar)
    else inn(avatar)
    end
  end
  
  def shop(avatar)
    clear_console
    puts "Welcome to #{avatar.city.shop.name}"
    puts "1.Buy item"
    puts "2.Sell item"
    puts "3.Leave"
    case read_ch-48
    when 1 then buy_shop(avatar)
    when 2 then sell_shop(avatar)
    when 3 then go_to_world(avatar)
    else shop(avatar)
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
    when 1 then item(avatar, "sword")
    when 2 then item(avatar, "bow")
    when 3 then item(avatar, "staff")
    when 4 then item(avatar, "armor")
    when 5 then shop(avatar)
    else shop(avatar)
    end
  end
  
  def item(avatar,item_class)
    item_list = avatar.city.shop.items.by_type(item_class)
    c = item_display(item_list)
    if(c < item_list.size+1)
      item_view(avatar, item_list[c-1])
    end
  end
  
  def sell_shop(avatar)
    clear_console
    puts "Select item to sell:"
    show_inventory(avatar,2)
    
  end
  
  def wilds(avatar)
    clear_console
    areas = avatar.city.fight_areas
    if(avatar.hp>0)
      if(areas.size > 0)
        puts "Go to:"
        areas.each_with_index{|x,y| puts "#{y+1}. #{x.name}"}
        c = read_ch-49
        go_to_area(avatar,areas[c])    
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
      when 1 then @world.start_fight(avatar, @world.find_arena_monster(avatar.city))
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
    if(area.monsters.size != 0)
      monster = area.monsters[Random.new.rand(0..area.monsters.size-1)]
      @world.start_fight(avatar, monster)
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
      when 2 then item(avatar, item.item_class)
      else item_view(avatar, item)
      end
    else
      case c
      when 2 then item(avatar,item.item_class)
      else item_view(avatar, item)
      end
    end
  end
  
  def item_display(item_list)
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
