require 'rbconfig'
require File.join(File.dirname(__FILE__), 'shop.rb')
class Ui
  @shop
  def initialize(world)
    @world = world
  end
  
  def login
    @shop = @world.shop_inst
    clear_console
    puts "Welcome"
    puts "1.Register"
    puts "2.Login"
    case read_ch-48
    when 1 then reg
    when 2 then logs
    end
  end
  
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
        puts 'avataracted does not exist or you entered incorrect password'
        login
      end
    end
    return avatar
  end
  
  def show_stats(avatar)
    clear_console
    puts "Name: #{avatar.name}"
    puts "Class: #{avatar.avatar_class}"
    puts "HP: #{avatar.hp}/#{avatar.max_hp}"
    puts "Mana: #{avatar.mana}/#{avatar.max_mana}"
    puts "Base damage: #{avatar.base_dmg_min}/#{avatar.base_dmg_max}"
    puts "Press any key to go back."
    read_ch
  end
  
  def show_inventory(avatar)
    clear_console
    if(avatar.backpack.class == Array)
      if(avatar.backpack.size != 0)
        avatar.backpack.each_with_index{|x,y| puts "#{y+1}. #{x.name}"}
        c = -1
        until (avatar.backpack.length>= c && c >= 0)
          c = gets
          c = c.chomp.to_i
        end
        item_view(avatar, avatar.backpack[c-1])
      else
        puts "Your inventory is empty."
      end
    end
  end
  
  def item_view(avatar, item)
    clear_console
    puts "Name: #{item.name}"
    puts "Class: #{item.item_class}"
    puts "Level requirement: #{item.level}"
    puts "Damage #{item.damage_min}/#{item.damage_max}"
    puts "Press any key to go back."
    read_ch
  end
  
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
    when 6 then show_inventory(avatar)
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
    else inn(avatar, read_ch-48)
    end
  end
  
  def shop(avatar,name)
    clear_console
    puts "Welcome to #{name}"
    puts "1. Buy sword."
    puts "2. Buy bow."
    puts "3. Buy magic staff."
    puts "4. Leave."
    case read_ch-48
    when 1 then @shop.item(avatar, "sword")
    when 2 then @shop.item(avatar, "bow")
    when 3 then @shop.item(avatar, "staff")
    when 4 then go_to_world(avatar)
    else shop(avatar, read_ch-48)
    end
  end
  
  def inspect(avatar,item)
    clear_console
    puts item.name
    puts "Level requirement: #{item.level}"
    puts "Damage #{item.damage_min}/#{item.damage_max}"
    puts "Price: #{item.price}"
    if(avatar.gold >= item.price)
      puts "1. Buy."
    else 
      puts "You do not have enough money."
    end
    puts "2. Go back."
    @shop.inspect(avatar,item,read_ch-48)
  end
  
  def item(item_list)
    clear_console
    item_list.each_with_index{|x,y| puts "#{y+1}. Inspect #{x.name}"}
    read_ch-48
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
      when 1 then @world.fight.fight(avatar, @world.find_arena_monster(@world.citys[avatar.current_city]))
      when 2 then go_to_world(avatar)
      else arena(avatar,read_ch-48)
      end
    else
      puts "You need to go to inn to rest."
      puts "Press any key to continue."
      read_ch
    end
  end
  
  def go_to_area(avatar,area)
   
  end
  
  def winner_msg(avatar)
    puts "You have WON the battle!"
    puts "Press any key to return to town."
    read_ch
  end
  
  def looser_msg(avatar)
    puts "You have LOST the battle."
    puts "Press any key to return to town."
    puts "Don`t forget to visit inn to heal your wounds."
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
    when 1 then @world.fight.attack(avatar, enemy)
    when 2 then @world.fight.skill(avatar, enemy)
    when 3 then @world.fight.use_item(avatar)
    else fight_menu(avatar, enemy, read_ch-48)
    end
  end
  
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
    else choose_class(avatar, read_ch-48)
    end
  end
end
