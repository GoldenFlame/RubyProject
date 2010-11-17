class Avatar < ActiveRecord::Base
  has_many :avatar_items
  attr_accessor :backpack, :eq_weapon, :eq_armor


  def experience_for_level
    next_level = level + 1
    (next_level ** 3) + ((next_level + 1) ** 3) + (next_level * 3)
  end
  
  def check_lvlup
    if(experience_for_level<=exp)
      self.exp = 0
      self.level = level + 1
    end
  end
  
  def backpack_init
    @backpack = []
    info = Avatar_item.find_all_by_user(id)
    if(info.class == Avatar_item)
      info.amount.times{@backpack.push(Item.find_by_id(info.item))} 
    elsif(info.class == Array)
      info.each{|x| x.amount.times{@backpack.push(Item.find_by_id(x.item))}}
    end
  end
  
  def equipment_init
    if(weapon != nil)
      @eq_weapon = Item.find_by_id(weapon)
    end
    if(armor != nil)
      @eq_armor = Item.find_by_id(armor)
    end
  end
  
  
  def equip(item)
    type = item.item_class
    if(type == "sword" || type == "bow" || type == "staff")
      if(weapon != nil)
        backpack.push(eq_weapon)
        info = Avatar_item.find_or_create_by_item(weapon)
        if(info.amount == nil)
          info.amount = 0
        end
        info.amount += 1
        info.save
      end
      @eq_weapon = item
      self.weapon = item.id
      info = Avatar_item.find_by_item(item.id)
      info.amount -= 1
      info.save
      backpack.delete_at(backpack.index(item))
    elsif(type == "armor")
      if(armor != nil)
        backpack.push(eq_armor)
        info = Avatar_item.find_or_create_by_item(armor)
        if(info.amount == nil)
          info.amount = 0
        end
        info.amount += 1
        info.save
      end
      @eq_armor = item
      self.armor = item.id
      info = Avatar_item.find_by_item(item.id)
      info.amount -= 1
      info.save
      
      backpack.delete_at(backpack.index(item))
    end
    self.save
  end
  
  def disequip(item)
    type = item.item_class
    if(type == "sword" || type == "bow" || type == "staff")
      @eq_weapon = nil
      self.weapon = nil 
    elsif(type == "armor")
      @eq_armor = nil
      self.armor = nil
    end
    info = Avatar_item.find_by_item(item.id)
    info.amount += 1
    info.save
    backpack.push(item)
    save
  end
  
end