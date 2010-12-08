class City < ActiveRecord::Base
  belongs_to :world
  has_many :fight_areas
  has_one :shop
  has_many :avatars
  
  def rest(avatar)
    avatar.hp = avatar.max_hp
    avatar.mana = avatar.max_mana
    avatar.save
  end
  
  def find_arena_monster
    if(self.fight_areas.size !=0)
      area = self.fight_areas[Random.new.rand(0..self.fight_areas.size-1)]
      monsters = area.monsters
      if(monsters.size != 0)
        return monsters[Random.new.rand(0..monsters.size-1)]
      end
    end
  end

  
end