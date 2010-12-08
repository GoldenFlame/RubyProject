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

  
end