class FightArea < ActiveRecord::Base  
  has_many :monsters
  has_many :fights
end