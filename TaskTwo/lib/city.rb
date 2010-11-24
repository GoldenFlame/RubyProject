class City < ActiveRecord::Base
  has_many :fight_areas
  has_one :shop
  has_many :avatars
end