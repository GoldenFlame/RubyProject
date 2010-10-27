require File.join(File.dirname(__FILE__), 'yaml_manage.rb')
require File.join(File.dirname(__FILE__), 'ui.rb')

class Fight
  @interface
  def initialize(interface)
    @interface = interface
  end
  def self.fight(char, enemy)
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
  
  def self.check_fight_end(char, monster)
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
  
  def self.player_prize(char, enemy)
    char[:exp] += enemy[:exp_bonus]
    char[:gold] += Random.new.rand(0..enemy[:gold_max])
  end
  
  def self.player_penalty(char,enemy)
    char[:exp] -= enemy[:exp_bonus] / 10
    char[:gold] -= Random.new.rand(0..enemy[:gold_max]) / 10
  end
  
  def self.attack(attacker, defender)
    dmg = Random.new.rand(attacker[:base_dmg_min]..attacker[:base_dmg_max])
    defender[:hp] -= dmg
  end
  
  def self.skill(attacker, defender)
    defender[:hp] -= attacker[:base_dmg_max] * 2
  end
  
  def self.use_item(attacker)
    attacker[:hp] += 10
  end
  
end