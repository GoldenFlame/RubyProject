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
  
  def go_to_area(area)
    if(area.monsters.size != 0)
      return monster = area.monsters[Random.new.rand(0..area.monsters.size-1)]
    end
  end

  def backpack_init
    
  end
  
  def class_warrior
    self.avatar_class = 1
    self.base_dmg_min = 20
    self.base_dmg_max = 30
    self.max_hp = 100
    self.hp = 100
    self.max_mana = 10
    self.mana = 10
    self.save
  end

  def class_archer
    self.avatar_class = 2
    self.base_dmg_min = 10
    self.base_dmg_max = 50
    self.max_hp = 75
    self.hp = 75
    self.max_mana = 30
    self.mana = 30
    self.save
  end
  
  def class_mage
    self.avatar_class = 3
    self.base_dmg_min = 10
    self.base_dmg_max = 20
    self.max_hp = 50
    self.hp = 50
    self.max_mana = 100
    self.mana = 100
    self.save
  end

  def attack(fight)
    if(eq_weapon != nil)
      dmg = Random.new.rand(base_dmg_min+eq_weapon.damage_min..base_dmg_max+eq_weapon.damage_max)
    else
      dmg = Random.new.rand(base_dmg_min..base_dmg_max)
    end
    fight.monster_hp -= dmg
    fight.save
  end
  
  def skill_attack(fight)
    if(eq_weapon != nil)
      dmg = Random.new.rand(base_dmg_min+eq_weapon.damage_min..base_dmg_max+eq_weapon.damage_max)
    else
      dmg = Random.new.rand(base_dmg_min..base_dmg_max)
    end
    fight.monster_hp -= dmg*2
    fight.save
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