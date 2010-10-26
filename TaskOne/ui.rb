
class Ui
  def initialize(world)
    @world = world
    puts "Welcome"
  end
  
  def login
    puts "1.Register"
    puts "2.Login"
    @world.login(read_ch-48)
  end
  
  def read_ch
    require "Win32API"
    Win32API.new("crtdll", "_getch", [], "L").Call
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
        login()
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
      if(char.class == :hash)
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
  
end
