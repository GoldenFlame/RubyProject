require 'rbconfig'
require File.join(File.dirname(__FILE__), 'shop.rb')
class Ui
  @shop
  def initialize(world)
    @world = world
    puts "Welcome"
  end
  
  def login
    @shop = @world.shop_inst
    clear_console
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
      char = @world.logs(name)
      if(char != nil)
        if(char[:password].chomp == pass.chomp)
          logged_in = true
          puts 'You successfully logged in.'
        end
      else
        puts 'Characted does not exist or you entered incorrect password'
        login
      end
    end
    return char
  end
  
  def show_stats(char)
    clear_console
    puts "Name: #{char[:name]}"
    puts "Class: #{char[:class]}"
    puts "HP: #{char[:hp]}/#{char[:max_hp]}"
    puts "Mana: #{char[:mana]}/#{char[:max_mana]}"
    puts "Base damage: #{char[:base_dmg_min]}/#{char[:base_dmg_max]}"
    puts "Press any key to go back."
    read_ch
  end
  
  def show_inventory(char)
    clear_console
    sw = 0
    bw = 0
    st = 0
    if(char[:backpack][:sword].class == Array.class)
      sw = char[:backpack][:sword].length 
    elsif(char[:backpack][:sword].class == String.class)
      sw = 1
    end
    if(char[:backpack][:bow].class == Array.class)
      bw = char[:backpack][:bow].length 
    elsif(char[:backpack][:bow].class == String.class)
      bw = 1
    end
    if(char[:backpack][:staff].class == Array.class)
      st = char[:backpack][:staff].length
    elsif(char[:backpack][:staff].class == String.class)
      st = 1
    end
    
    puts "Your inventory:"
    if(sw != 0 || bw != 0 || st != 0)
      puts "1. Swords(#{sw})" if(sw != 0)
      puts "2. Bows(#{bw})" if(bw != 0)
      puts "3. Staffs(#{st})" if(st != 0)
      puts "4. Go back"
    else 
      puts "Your inventory is empty."
    end
    @world.show_inventory(char,read_ch-48)
  end
  
  def item_menu_inventory(char, arg)
    clear_console
    if(char[:backpack][arg].class == Array.class)
      
      char[:backpack][arg].each_with_index{|x,y| puts "#{y+1}. #{x}"}
      c = -1
      until (char[:backpack][arg].length-1>= c && c >= 0)
        c = read_ch - 49
      end
      
      item_view(char,arg, char[:backpack][arg][c])
    end
  end
  
  def item_view(char,arg, item_name)
    clear_console
    item = @world.find_item(arg, item_name)
    puts "Name: #{item[:name]}"
    puts "Class: #{item[:class]}"
    puts "Level requirement: #{item[:level]}"
    puts "Damage #{item[:damage_min]}/#{item[:damage_max]}"
    puts "Press any key to go back."
    read_ch
  end
  
  def go_to_world(char)
    puts "1. Go to arena."
    puts "2. Go to the wilds."
    puts "3. Go to the shop."
    puts "4. Go to the inn."
    puts "5. View your stats."
    puts "6. View your inventory."
    puts "7. Exit game"
    @world.go_to_world(char,read_ch-48)
  end
  
  def inn(char,name)
    clear_console
    puts "Welcome to #{name}"
    puts "1.Rest and regain your strength."
    puts "2.Leave."
    @world.inn(char,read_ch-48)
  end
  
  def shop(char,name)
    clear_console
    puts "Welcome to #{name}"
    puts "1. Buy sword."
    puts "2. Buy bow."
    puts "3. Buy magic staff."
    puts "4. Leave."
    @world.shop(char,read_ch-48)
  end
  
  def inspect(char,item)
    clear_console
    puts item[:name]
    puts "Level requirement: #{item[:level]}"
    puts "Damage #{item[:damage_min]}/#{item[:damage_max]}"
    if(char[:gold] >= item[:price])
      puts "1. Buy."
    else 
      puts "You do not have enough money."
    end
    puts "2. Go back."
    @shop.inspect(char,item,read_ch-48)
  end
  
  def item(item_list)
    clear_console
    item_list.each_with_index{|x,y| puts "#{y+1}. Inspect #{x[:name]}"}
    read_ch-48
  end

  def wilds(char,city)
    clear_console
    if(city[:fight_area].to_i !=0)
      puts "Go to:"
      (1..city[:fight_area].to_i).collect{|x| area = "fight_#{x.to_s}"; puts x.to_s+". "+city[area.to_sym]}
      @world.wilds(char,read_ch,city)      
    else
      puts "There are no wild areas which you can visit now."
    end
  end
  
  def arena(char)
    clear_console
    puts "Welcome to the arena."
    puts "1.Fight random monster."
    puts "2.Go back."
    @world.arena(char,read_ch-48)
  end
  
  def go_to_area(char,area)
   
  end
  
  def battle_info(char, enemy)
    puts "You are finghting #{enemy[:name]}"
    puts "Your stats:"
    puts "HP: #{char[:hp]}/#{char[:max_hp]}"
    puts "Mana: #{char[:mana]}/#{char[:max_mana]}"
    puts "Base damage: #{char[:base_dmg_min]}/#{char[:base_dmg_max]}"
    puts "----"
    puts "#{enemy[:name]} stats:"
    puts "HP: #{enemy[:hp]}/#{enemy[:max_hp]}"
    puts "Base damage: #{enemy[:base_dmg_min]}/#{enemy[:base_dmg_max]}"
  end
  
  def fight_menu(char,enemy)
    puts "1.Basic attack"
    puts "2.Skill attack"
    puts "3.Use item"
    puts "4.Run away"
    @world.fight_menu(char, enemy,read_ch-48)
  end
  
  def choose_class(char)
    clear_console
    puts 'Choose your characters class'
    puts '1. Warrior(Melee fighter)'
    puts '2. Archer(Ranged fighter)'
    puts '3. Mage(Magic fighter)'
    @world.choose_class(char,read_ch-48)
  end
  
end
