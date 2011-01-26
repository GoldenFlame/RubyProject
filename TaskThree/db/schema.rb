# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# Note that this schema.rb definition is the authoritative source for your
# database schema. If you need to create the application database on another
# system, you should be using db:schema:load, not running all the migrations
# from scratch. The latter is a flawed and unsustainable approach (the more migrations
# you'll amass, the slower it'll run and the greater likelihood for issues).
#
# It's strongly recommended to check this file into your version control system.

ActiveRecord::Schema.define(:version => 0) do
  create_table :avatars do |t|
    t.string :name
    t.string :password
    t.integer :avatar_class
    t.integer :level
    t.integer :exp
    t.integer :city_id
    t.integer :gold
    t.integer :base_dmg_min
    t.integer :base_dmg_max
    t.integer :max_hp
    t.integer :hp
    t.integer :max_mana
    t.integer :mana
    t.integer :weapon
    t.integer :armor
  end

  create_table :avatar_items do |t|
    t.integer :avatar_id
    t.integer :item_id
    t.integer :amount
  end

  create_table :cities do |t|
    t.string :name
  end

  create_table :fights do |t|
    t.integer :avatar_id
    t.integer :monster_id
    t.integer :fight_area_id
    t.integer :monster_hp
    t.boolean :ended
  end

  create_table :fight_areas do |t|
    t.string :name
    t.integer :city_id
  end

  create_table :items do |t|
    t.string :name
    t.string :item_class
    t.integer :level
    t.integer :price
    t.integer :damage_min
    t.integer :damage_max
    t.integer :armor
  end

  create_table :monsters do |t|
    t.string :name
    t.integer :fight_area_id
    t.integer :max_hp
    t.integer :base_dmg_min
    t.integer :base_dmg_max
    t.integer :exp_bonus
    t.integer :gold_max
  end

  create_table :shops do |t|
    t.string :name
    t.integer :city_id
  end

  create_table :shop_items do |t|
    t.integer :shop_id
    t.integer :item_id
  end
end
