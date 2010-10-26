require File.join(File.dirname(__FILE__), 'yaml_manage.rb')
require File.join(File.dirname(__FILE__), 'ui.rb')

class World
  @interface
  @city
  @exitcmd
  def initialize 
    @exitcmd = false
    world = YamlManage.load_file("data/world.yml")
    cities_number = world[:cities]
    @city = (1..cities_number.to_i).collect{|x| YamlManage.load_file("data/city/#{world[x.to_s.to_sym]}.yml")}
    @interface = Ui.new(self)
  end
  
  def exit
    @exitcmd = true
  end  
  
  def get_interface
    @interface
  end
  
  def main_menu
    char = @interface.login()
    res = nil
    while(true)
      if(char[:class] == 0)
        res = @interface.choose_class(char)
      else 
        res = check_lvlup(char), @interface.go_to_world(char)
      end
      break if(@exitcmd) 
    end
    return res
  end
  
  def autosave(char)
    YamlManage.save_char(char)
  end
  
  
end
