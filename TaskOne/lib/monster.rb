class Monster < Entity
  attr_reader :name, :level, :base_dmg_min, :base_dmg_max, :max_hp, :exp_bonus, :gold_max
  attr_accessor :hp
end