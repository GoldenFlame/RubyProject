class YamlManage
  def self.create_user(name, pass)
    output = File.new("data/user/#{name.chomp}.yml", 'w')
    @preferences = {:name => name.chomp,
      :password => pass.chomp, 
      :class => 0,
      :level => 1,
      :exp => 0,
      :current_city => 0,
      :gold => 100,
      :base_dmg_min => 0,
      :base_dmg_max => 0,
      :max_hp => 10,
      :hp => 10,
      :max_mana => 10,
      :mana => 10,
      :backpack => [],
      :equiped => {:weapon => nil, :armor => nil}
      };
    output.puts YAML.dump(@preferences)
    output.close
  end
  
  def self.save_char(avatar)
    output = File.new("data/user/#{avatar[:name]}.yml", 'w')
    output.puts YAML.dump(avatar)
    output.close
  end
  
  
  def self.load_file(path)
    output = File.new(path.chomp, 'r')
    @preferences = YAML.load(output.read)
    output.close
    return @preferences
  end
end
