class Monster < Entity
  attr_accessor :name, :level, :base_dmg_min, :base_dmg_max, :max_hp, :hp, :exp_bonus, :gold_max
  def parse(data)
    @name = data[:name]
    @level = data[:level]
    @base_dmg_min = data[:base_dmg_min]
    @base_dmg_max = data[:base_dmg_max]
    @max_hp = data[:max_hp]
    @hp = data[:hp]
    @exp_bonus = data[:exp_bonus]
    @gold_max = data[:gold_max]
  end
end