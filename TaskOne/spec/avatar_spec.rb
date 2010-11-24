require File.dirname(__FILE__) + '/spec_helper.rb'
SimpleCov.start
describe "avatar" do
  before(:all) do
    YamlManage.create_user("test","test") if(!File.exist? "data/user/test.yml")
  end
  
  before(:each) do
    @avatar = Avatar.new('data/user/test.yml')
    @monster = Monster.new("data/monster/Sin.yml")
  end
  
  describe "Initialize" do
    it"should load file when object created" do
      expected = {:name => 'test',
        :password => 'test',
        :avatar_class => 0,
        :level => 1,
        :exp => 0,
        :current_city => 0,
        :gold => 100,
        :base_dmg_min => 0,
        :base_dmg_max => 0,
        :max_hp => 10,
        :hp => 10,
        :max_mana => 10,
        :mana => 10}
      @avatar.should be_loaded_with(expected)
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
    it"should load item Wooden sword" do
      weapon, armor = @avatar.equipment_init('Wooden sword', nil)
      weapon.name.should == 'Wooden sword'
    end
    
    it"should load item Leather armor" do
      weapon, armor = @avatar.equipment_init(nil, "Leather armor")
      armor.name.should == 'Leather armor'
    end
    
    it"should not load any items" do
      weapon, armor = @avatar.equipment_init(nil, nil)
      weapon.should == nil
      armor.should == nil
    end
  end
  
  
  describe "attack" do
    it "should decrease monsters health points by 1 when avatar has no weapon" do
      #damage is calculated by taking random number in range of avataracters min damage and max damage
      #therefor mock object a returning value 1 instead of random
      a = mock("Random", {:rand => 1})
      Random.stub!(:new).and_return(a)
      @avatar.attack(@monster)
      @monster.hp.should == 74
    end
      
    it "should decrease monsters health points by 2 when avatar has a weapon" do
      #damage is calculated by taking random number in range of avataracters min damage and max damage
      #therefor mock object a returning value 1 instead of random
      a = mock("Random", {:rand => 2})
      Random.stub!(:new).and_return(a)
      @avatar.eq_weapon = Item.new("data/item/sword1.yml")
      @avatar.attack(@monster)
      @monster.hp.should == 73
    end
      
      
  end
    
  describe "skill attack" do
    it "should decrease defenders health points by 20" do
      a = mock("Random", {:rand => 2})
      Random.stub!(:new).and_return(a)  
      @avatar.base_dmg_min = 10
      @avatar.base_dmg_max = 10
      @avatar.skill_attack(@monster)
      
      @monster.hp.should == 71
    end
  end
    
  describe "heal" do
    it "should increase avatars health points by 10" do
    @avatar.hp = 0
    @avatar.heal
    @avatar.hp.should be_equal(10)
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
    
    it"should put equiped leather armor into backpack" do
      leather_armor = Item.new("data/item/armor1.yml")
      chainmail_armor = Item.new("data/item/armor2.yml")
      @avatar.eq_armor = leather_armor
      @avatar.equip(chainmail_armor)
      @avatar.backpack.should include(leather_armor)
    end
    
    it"should put equiped item wooden bow into backpack and equip wooden sword" do
      sword = Item.new("data/item/sword1.yml")
      bow = Item.new("data/item/bow1.yml")
      @avatar.eq_weapon = bow
      @avatar.equip(sword)
      @avatar.backpack.should include(bow)
    end
  end
  
  describe "disequip" do
    it"should disequip Leather armor" do
      item = Item.new("data/item/armor1.yml")
      @avatar.equip(item)
      @avatar.disequip(item)
      @avatar.backpack.should include(item)
      @avatar.eq_armor.should == nil
    end
    
    it"should disequip Wooden sword" do
      item = Item.new("data/item/sword1.yml")
      @avatar.equip(item)
      @avatar.disequip(item)
      @avatar.eq_weapon.should == nil
    end
    
    it"should include disequiped Leather armor in backpack" do
      item = Item.new("data/item/armor1.yml")
      @avatar.equip(item)
      @avatar.disequip(item)
      @avatar.backpack.should include(item)
    end
    
    it"should include disequiped sword in backpack" do
      item = Item.new("data/item/sword1.yml")
      @avatar.equip(item)
      @avatar.disequip(item)
      @avatar.backpack.should include(item)
    end
    
  end
  
  describe "to hash" do
    it "should convert avatar object to hash" do
      @avatar.eq_weapon = Item.new("data/item/sword1.yml")
      expected = {:name => 'test',
        :password => 'test',
        :avatar_class => 0,
        :level => 1,
        :exp => 0,
        :current_city => 0,
        :gold => 100,
        :base_dmg_min => 0,
        :base_dmg_max => 0,
        :max_hp => 10,
        :hp => 10,
        :max_mana => 10,
        :mana => 10}
      @avatar.to_hash.should have_hash_values(expected)
    end
  end
  after(:all) do
    File.delete("data/user/test.yml") if File.exists?("data/user/test.yml")
  end
end