class Fight < ActiveRecord::Base  
  belongs_to :avatar
  belongs_to :monster
  belongs_to :fight_area
  
  def check_fight_end(avatar, monster)
    defeat = false
    if(monster_hp <= 0)
      defeat = true
      player_prize(avatar, monster)
    elsif(avatar.hp <= 0)
      defeat = true
      player_penalty(avatar, monster)
    end
    return defeat
  end
  
  def player_prize(avatar, enemy)
    avatar.exp += enemy.exp_bonus
    avatar.gold += Random.new.rand(0..enemy.gold_max)
  end
  
  def player_penalty(avatar,enemy)
    avatar.gold -= Random.new.rand(0..enemy.gold_max) / 10
  end 
  
    def find_arena_monster(city)
    if(city.fight_areas.size !=0)
      area = city.fight_areas[Random.new.rand(0..city.fight_areas.size-1)]
      monsters = area.monsters
      if(monsters.size != 0)
        monsters[Random.new.rand(0..monsters.size-1)]
      end
    end
  end   
  
end