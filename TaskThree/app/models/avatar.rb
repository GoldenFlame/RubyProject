class Avatar < ActiveRecord::Base
  has_many :avatar_items
  has_many :items, :through => :avatar_items
  has_one :fight
  belongs_to :city
  attr_accessor :backpack, :eq_weapon, :eq_armor

  def travel(citya)
    self.city = citya
    self.save
  end
  
  

  def attack(enemy)
    if(eq_weapon != nil)
      dmg = Random.new.rand(base_dmg_min+eq_weapon.damage_min..base_dmg_max+eq_weapon.damage_max)
    else
      dmg = Random.new.rand(base_dmg_min..base_dmg_max)
    end
    return dmg
  end
  
  def skill_attack(enemy)
    if(eq_weapon != nil)
      dmg = Random.new.rand(base_dmg_min+eq_weapon.damage_min..base_dmg_max+eq_weapon.damage_max)
    else
      dmg = Random.new.rand(base_dmg_min..base_dmg_max)
    end
    return dmg*2
  end
  
  def heal
    self.hp += 10
  end

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
    info = avatar_items
    info.each{|x| x.amount.times{@backpack.push(Item.find_by_id(x.item_id))}}
  end
  
  def equipment_init
    if(weapon != nil)
      @eq_weapon = Item.find_by_id(weapon)
    end
    if(armor != nil)
      @eq_armor = Item.find_by_id(armor)
    end
  end
  
  def buy_item(item)
    self.gold -= item.price
    itemdb = AvatarItem.find_or_create_by_avatar_id_and_item_id(self.id, item.id)
    if(itemdb.amount == nil)
      itemdb.amount = 0
    end
    itemdb.amount += 1
    itemdb.save
    self.save
  end
  
  def sell_item(item)
    self.gold += item.price/2
    itemdb = AvatarItem.find_by_avatar_id_and_item_id(self.id, item.id)
    itemdb.amount -= 1
    itemdb.save
    self.save
  end

  
  def equip(item)
    type = item.item_class
    if(type == "sword" || type == "bow" || type == "staff")
      if(weapon != nil)
        info = AvatarItem.find_or_create_by_item_id(weapon)
        if(info.amount == nil)
          info.amount = 0
        end
        info.amount += 1
        info.save
      end
      @eq_weapon = item
      self.weapon = item.id
      info = AvatarItem.find_by_avatar_id_and_item_id(self.id,item.id)
      info.amount -= 1
      info.save
    elsif(type == "armor")
      if(armor != nil)
        info = AvatarItem.find_or_create_by_item_id(armor)
        if(info.amount == nil)
          info.amount = 0
        end
        info.amount += 1
        info.save
      end
      @eq_armor = item
      self.armor = item.id
      info = AvatarItem.find_by_item_id(item.id)
      info.amount -= 1
      info.save
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
    info = AvatarItem.find_by_item_id(item.id)
    info.amount += 1
    info.save
    save
  end
  
end