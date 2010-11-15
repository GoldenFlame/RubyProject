
class Fight
  attr_accessor :interface
  def initialize(interface)
    @interface = interface
  end
  def fight(avatar, enemy)
    monster = Monster.new("data/monster/#{enemy}.yml")
    defeat = false
    while(!defeat)
      @interface.clear_console
      @interface.battle_info(avatar, monster)
      @interface.fight_menu(avatar, monster)
      attack(monster,avatar)
      defeat = check_fight_end(avatar,monster)
      avatar.save
    end
  end
  
  def check_fight_end(avatar, monster)
    defeat = false
    if(monster.hp <= 0)
      defeat = true
      player_prize(avatar, monster)
    elsif(avatar.hp <= 0)
      defeat = true
      player_penalty(avatar, monster)
    end
    return defeat
  end
  
  def player_prize(avatar, enemy)
    @interface.winner_msg(avatar)
    avatar.exp += enemy.exp_bonus
    avatar.gold += Random.new.rand(0..enemy.gold_max)
  end
  
  def player_penalty(avatar,enemy)
    @interface.looser_msg(avatar)
    avatar.gold -= Random.new.rand(0..enemy.gold_max) / 10
  end
  
  def attack(attacker, defender)
    if(attacker.instance_of?(Avatar))
      if(attacker.eq_weapon != nil)
        dmg = Random.new.rand(attacker.base_dmg_min+attacker.eq_weapon.damage_min..attacker.base_dmg_max+attacker.eq_weapon.damage_max)
      else
        dmg = Random.new.rand(attacker.base_dmg_min..attacker.base_dmg_max)
      end
    else
      dmg = Random.new.rand(attacker.base_dmg_min..attacker.base_dmg_max)
    end
    if(defender.instance_of?(Avatar))
      if(defender.eq_armor != nil)
        dmg = dmg - dmg * defender.eq_armor.armor / (100 + defender.eq_armor.armor)
      end
    end
    defender.hp -= dmg
  end
  
  def skill(attacker, defender)
    defender.hp -= attacker.base_dmg_max * 2
  end
  
  def use_item(attacker)
    attacker.hp += 10
  end
  
end