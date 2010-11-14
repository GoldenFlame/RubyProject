class Avatar < Entity
  attr_accessor :name, :password, :avatar_class, :level, :exp,
  :current_city, :gold, :base_dmg_min, :base_dmg_max, :max_hp,
  :hp, :max_mana, :mana, :backpack, :eq_weapon, :eq_armor
  def parse(data)
    super
    @backpack = backpack_init(data[:backpack])
    @eq_weapon, @eq_armor = equipment_init(data[:equiped][:weapon], data[:equiped][:armor])
  end
  
  def equipment_init(weapon, armor)
    if(weapon != nil)
      eq_weapon = Item.new("data/item/#{Item.find_file_name(weapon)}.yml")
    else
      eq_weapon = nil
    end
    if(armor != nil)
      eq_armor = Item.new("data/item/#{Item.find_file_name(armor)}.yml")
    else
      eq_armor = nil
    end
    return eq_weapon, eq_armor
  end
    
  
  def backpack_init(backpack)
    if(backpack == nil)
      backpack = []
    end
    backpack.collect!{|x| Item.new("data/item/#{Item.find_file_name(x)}.yml")} 
  end
  
  def save
    YamlManage.save_char(to_hash)
  end
  
  def equip(item)
    type = item.item_class
    if(type == "sword" || type == "bow" || type == "staff")
      if(@eq_weapon != nil)
        @backpack.push(@eq_weapon)
      end
      @eq_weapon = item.clone
      @backpack.delete(item)
    elsif(type == "armor")
      if(@eq_armor != nil)
        @backpack.push(@eq_armor)
      end
      @eq_armor = item.clone
      @backpack.delete(item)
      @eq_armor = item
    end
    save
  end
  
  def disequip(item)
    type = item.item_class
    if(type == "sword" || type == "bow" || type == "staff")
      @eq_weapon = nil
      @backpack.push(item)
    elsif(type == "armor")
      @eq_armor = nil
      @backpack.push(item)
    end
    save
  end
  
  def to_hash
    hash_weapon = nil
    hash_armor = nil
    
    if(@eq_weapon != nil)
      hash_weapon = @eq_weapon.name
    end
    if(@eq_armor != nil)
      hash_armor = @eq_armor.name
    end
      
    hash = {:name => @name,
      :password => @password,
      :avatar_class => @avatar_class,
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
      :backpack => @backpack.collect{|x| x.name},
      :equiped => {:weapon => hash_weapon, :armor => hash_armor}
      };
  end
end