class Avatar < Entity
  attr_accessor :name, :password, :avatar_class, :level, :exp,
  :current_city, :gold, :base_dmg_min, :base_dmg_max, :max_hp,
  :hp, :max_mana, :mana, :backpack
  def parse(data)
    @name = data[:name]
    @password = data[:password]
    @avatar_class = data[:class]
    @level = data[:level]
    @exp = data[:exp]
    @current_city = data[:current_city]
    @gold = data[:gold]
    @base_dmg_min = data[:base_dmg_min]
    @base_dmg_max = data[:base_dmg_max]
    @max_hp = data[:max_hp]
    @hp = data[:hp]
    @max_mana = data[:max_mana]
    @mana = data[:mana]
    @backpack = data[:backpack]
  end
  
  def save
    YamlManage.save_char(to_hash)
  end
  
  def to_hash
    hash = {:name => @name,
      :password => @password,
      :class => @avatar_class,
      :level => @level,
      :exp => @exp,
      :current_city => @current_city,
      :gold => @gold,
      :base_dmg_min => @base_dmg_min,
      :base_dmg_max => @base_dmg_max,
      :max_hp => @max_hp,
      :hp => @hp,
      :max_mana => @max_mana,
      :mana => @mana,
      :backpack => @backpack
      };
  end
end