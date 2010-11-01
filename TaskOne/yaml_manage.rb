require 'yaml'

class YamlManage
  def self.create_char(name, pass)
    output = File.new("data/user/#{name.chomp}.yml", 'w')
    @preferences = {:name => name.chomp,
      :password => pass.chomp, 
      :class => 0, 
      :level => 1, 
      :exp => 0,
      :current_city => 0,
      :gold => 100
      };
    output.puts YAML.dump(@preferences)
    output.close
  end
  
  def self.save_char(char)
    output = File.new("data/user/#{char[:name].chomp}.yml", 'w')
    output.puts YAML.dump(char)
    output.close
  end
  
  
  def self.load_file(path)
    output = File.new(path.chomp, 'r')
    @preferences = YAML.load(output.read)
    output.close
    return @preferences
  end
end
