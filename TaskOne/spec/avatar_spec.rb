require File.dirname(__FILE__) + '/spec_helper.rb'
SimpleCov.start
describe "avatar" do
  before(:all) do
    YamlManage.create_user("test","test") if(!File.exist? "data/user/test.yml")
  end
  
  before(:each) do
    @avatar = Avatar.new('data/user/test.yml')
  end
  
  describe "Initialize" do
    it"should load file when object created" do
      @avatar.name.should == 'test'
      @avatar.password.should == 'test'
      @avatar.avatar_class.should == 0
      @avatar.level.should == 1
      @avatar.exp.should == 0
      @avatar.current_city.should == 0
      @avatar.gold.should == 100
      @avatar.base_dmg_min.should == 0
      @avatar.base_dmg_max.should == 0
      @avatar.max_hp.should == 10
      @avatar.hp.should == 10
      @avatar.max_mana.should == 10
      @avatar.mana.should == 10
    end
  end
  
  describe "backpack initialization" do
    it"should load avatars items" do
      @avatar.backpack = nil
      backpack = ['Wooden sword', 'Leather armor']
      @avatar.backpack = @avatar.backpack_init(backpack)
      @avatar.backpack.should have(2).items
    end
  end
  
  describe "save" do
    it"should save avatars stats" do
      @avatar.should_receive(:save)
      @avatar.save
    end
  end
  
  describe "equipment initialization" do
    it"should load item Wooden sword and no armor" do
      weapon, armor = @avatar.equipment_init('Wooden sword', nil)
      weapon.name.should == 'Wooden sword'
      armor.should == nil
    end
    
    it"should not load any items" do
      weapon, armor = @avatar.equipment_init(nil, nil)
      weapon.should == nil
      armor.should == nil
    end
  end
  
  describe "level up" do
    describe "experience for level" do
      it "should return 50 for level 2" do
        @avatar.level = 1
        @avatar.experience_for_level.should == 41
      end
        
      it "should return 100 for level 3" do
        @avatar.level = 2
        @avatar.experience_for_level.should == 100
      end
    end
    
    describe "check level up" do
      it "should set avatar`s level to 2" do
        @avatar.level = 1
        @avatar.exp = 100
        @avatar.check_lvlup
        @avatar.level.should == 2
      end
      
      it "should set avatar`s level to 10" do
        @avatar.level = 9
        @avatar.exp = 5000
        @avatar.check_lvlup
        @avatar.level.should == 10
      end
    end
  end
  
  
  
  describe "equip" do
    it"should equip item wooden sword" do
      item = Item.new("data/item/sword1.yml")
      @avatar.eq_weapon = nil
      @avatar.equip(item)
      @avatar.eq_weapon.should == item
    end
    
    it"should equip leather armor" do
      item = Item.new("data/item/armor1.yml")
      @avatar.eq_armor = nil
      @avatar.equip(item)
      @avatar.eq_armor.should == item
    end
    
    it"should put equiped leather armor into backpack and equip Chainmail armor" do
      leather_armor = Item.new("data/item/armor1.yml")
      chainmail_armor = Item.new("data/item/armor2.yml")
      @avatar.eq_armor = leather_armor
      @avatar.equip(chainmail_armor)
      @avatar.eq_armor.should == chainmail_armor
      @avatar.backpack.should include(leather_armor)
    end
    
    it"should put equiped item wooden bow into backpack and equip wooden sword" do
      sword = Item.new("data/item/sword1.yml")
      bow = Item.new("data/item/bow1.yml")
      @avatar.eq_weapon = bow
      @avatar.equip(sword)
      @avatar.eq_weapon.should == sword
      @avatar.backpack.should include(bow)
    end
  end
  
  describe "disequip" do
    it"should disequip Leather armor" do
      item = Item.new("data/item/armor1.yml")
      @avatar.equip(item)
      @avatar.eq_armor.should == item
      @avatar.disequip(item)
      @avatar.backpack.should include(item)
      @avatar.eq_armor.should == nil
    end
    
    it"should disequip Wooden sword" do
      item = Item.new("data/item/sword1.yml")
      @avatar.equip(item)
      @avatar.eq_weapon.should == item
      @avatar.disequip(item)
      @avatar.backpack.should include(item)
      @avatar.eq_weapon.should == nil
    end
  end
  
  describe "to hash" do
    it "should convert avatar object to hash" do
      @avatar.eq_weapon = Item.new("data/item/sword1.yml")
      hash = @avatar.to_hash
      hash[:name].should == 'test'
      hash[:password].should == 'test'
      hash[:avatar_class].should == 0
      hash[:level].should == 1
      hash[:exp].should == 0
      hash[:current_city].should == 0
      hash[:gold].should == 100
      hash[:base_dmg_min].should == 0
      hash[:base_dmg_max].should == 0
      hash[:max_hp].should == 10
      hash[:hp].should == 10
      hash[:max_mana].should == 10
      hash[:mana].should == 10
      hash[:equiped][:weapon].should == 'Wooden sword'
    end
  end
  after(:all) do
    File.delete("data/user/test.yml") if File.exists?("data/user/test.yml")
  end
end