require File.join(File.dirname(__FILE__), 'yaml_manage.rb')
require File.join(File.dirname(__FILE__), 'ui.rb')


class Fight
  attr_accessor :interface
  def initialize(interface)
    @interface = interface
  end
  def fight(char, enemy)
    monster = YamlManage.load_file("data/entity/#{enemy}.yml")
    defeat = false
    while(!defeat)
      @interface.clear_console
      @interface.battle_info(char, monster)
      @interface.fight_menu(char, monster)
      attack(monster,char)
      defeat = check_fight_end(char,monster)
      YamlManage.save_char(char)
    end
  end
  
  def check_fight_end(char, monster)
    defeat = false
    if(monster[:hp] <= 0)
      defeat = true
      player_prize(char, monster)
    elsif(char[:hp] <= 0)
      defeat = true
      player_penalty(char, monster)
    end
    return defeat
  end
  
  def player_prize(char, enemy)
    @interface.winner_msg(char)
    char[:exp] += enemy[:exp_bonus]
    char[:gold] += Random.new.rand(0..enemy[:gold_max])
  end
  
  def player_penalty(char,enemy)
    @interface.looser_msg(char)
    char[:exp] -= enemy[:exp_bonus] / 10
    char[:gold] -= Random.new.rand(0..enemy[:gold_max]) / 10
  end
  
  def attack(attacker, defender)
    dmg = Random.new.rand(attacker[:base_dmg_min]..attacker[:base_dmg_max])
    defender[:hp] -= dmg
  end
  
  def skill(attacker, defender)
    defender[:hp] -= attacker[:base_dmg_max] * 2
  end
  
  def use_item(attacker)
    attacker[:hp] += 10
  end
  
end