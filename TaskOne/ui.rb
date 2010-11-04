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
    @world.login(read_ch-48)
  end
  
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
    sw = 0
    bw = 0
    st = 0
    if(avatar.backpack[:sword].class == Array)
      sw = avatar.backpack[:sword].length 
    elsif(avatar.backpack[:sword].class == String)
      sw = 1
    end
    if(avatar.backpack[:bow].class == Array)
      bw = avatar.backpack[:bow].length 
    elsif(avatar.backpack[:bow].class == String)
      bw = 1
    end
    if(avatar.backpack[:staff].class == Array)
      st = avatar.backpack[:staff].length
    elsif(avatar.backpack[:staff].class == String)
      st = 1
    end
    puts "Your inventory:"
    if(sw != 0 || bw != 0 || st != 0)
      puts "1. Swords(#{sw})" if(sw != 0)
      puts "2. Bows(#{bw})" if(bw != 0)
      puts "3. Staffs(#{st})" if(st != 0)
      puts "4. Go back"
    elsif(sw != 0 && bw != 0 && st != 0)
      puts "Your inventory is empty."
    end
    @world.show_inventory(avatar,read_ch-48, sw, bw, st)
  end
  
  def item_menu_inventory(avatar, arg)
    clear_console
    if(avatar.backpack[arg].class == Array)
      avatar.backpack[arg].each_with_index{|x,y| puts "#{y+1}. #{x}"}
      c = -1
      until (avatar.backpack[arg].length>= c && c >= 0)
        c = gets
        c = c.chomp.to_i
      end
      item_view(avatar,arg, avatar.backpack[arg][c-1])
    end
  end
  
  def item_view(avatar,arg, item_name)
    clear_console
    item = @world.find_item(item_name)
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
    @world.go_to_world(avatar,read_ch-48)
  end
  
  def inn(avatar,name)
    clear_console
    puts "Welcome to #{name}"
    puts "1.Rest and regain your strength."
    puts "2.Leave."
    @world.inn(avatar,read_ch-48)
  end
  
  def shop(avatar,name)
    clear_console
    puts "Welcome to #{name}"
    puts "1. Buy sword."
    puts "2. Buy bow."
    puts "3. Buy magic staff."
    puts "4. Leave."
    @world.shop(avatar,read_ch-48)
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
        @world.wilds(avatar,read_ch,city)      
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
      @world.arena(avatar,read_ch-48)
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
    @world.fight_menu(avatar, enemy,read_ch-48)
  end
  
  def choose_class(avatar)
    clear_console
    puts 'Choose your avataracters class'
    puts '1. Warrior(Melee fighter)'
    puts '2. Archer(Ranged fighter)'
    puts '3. Mage(Magic fighter)'
    @world.choose_class(avatar,read_ch-48)
  end
  
end
