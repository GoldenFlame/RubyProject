require File.dirname(__FILE__) + '/spec_helper.rb'
SimpleCov.start
Blueprints.enable
describe "avatar" do
  before(:each) do
    build :avatar
    build :item_armor
    build :item_weapon
    build :item_armor2
    build :item_weapon2

    
    @avatar.avatar_items.create(:amount => 1, :item_id => @item_armor.id)
    @avatar.avatar_items.create(:amount => 1, :item_id => @item_weapon.id)
    @avatar.avatar_items.create(:amount => 1, :item_id => @item_armor2.id)
    @avatar.avatar_items.create(:amount => 1, :item_id => @item_weapon2.id)
    @avatar.backpack_init
  end
  
  describe "backpack initialization" do
    it"should load five avatar items from database" do
      @avatar.backpack = nil
      @avatar.backpack_init
      @avatar.backpack.should have(5).item
    end
  end
  
  
  describe "equipment initialization" do
    it"should load item test sword and test armor" do
      @avatar.weapon = @item_weapon.id
      @avatar.armor = @item_armor.id
      @avatar.equipment_init
      @avatar.eq_weapon.name.should == 'test sword'
      @avatar.eq_armor.name.should == 'test armor'
    end
    
    it"should not load any items" do
      @avatar.weapon = nil
      @avatar.armor = nil
      @avatar.equipment_init
      @avatar.eq_weapon.should == nil
      @avatar.eq_armor.should == nil
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
    it"should equip sword" do
      @avatar.eq_weapon = nil
      @avatar.equip(@item_weapon)
      @avatar.eq_weapon.should == @item_weapon
      @avatar.weapon.should == @item_weapon.id
    end
    
    it"should equip armor" do
      @avatar.eq_armor = nil
      @avatar.equip(@item_armor)
      @avatar.eq_armor.should == @item_armor
      @avatar.armor.should == @item_armor.id
    end
    
    it"should put equiped test armor into backpack and test metal armor" do
      @avatar.armor = @item_armor.id
      @avatar.eq_armor = @item_armor
      @avatar.equip(@item_armor2)
      @avatar.eq_armor.should == @item_armor2
      @avatar.backpack.should include(@item_armor)
    end
    
    it"should put equiped item test bow into backpack and equip test sword" do
      @avatar.weapon = @item_weapon.id
      @avatar.eq_weapon = @item_weapon
      @avatar.equip(@item_weapon2)
      @avatar.eq_weapon.should == @item_weapon2
      @avatar.backpack.should include(@item_weapon)
    end
  end
  
  describe "disequip" do
    it"should disequip test armor" do
      @avatar.equip(@item_armor)
      @avatar.eq_armor.should == @item_armor
      @avatar.disequip(@item_armor)
      @avatar.backpack.should include(@item_armor)
      @avatar.eq_armor.should == nil
    end
    
    it"should disequip test sword" do
      @avatar.equip(@item_weapon)
      @avatar.eq_weapon.should == @item_weapon
      @avatar.disequip(@item_weapon)
      @avatar.backpack.should include(@item_weapon)
      @avatar.eq_weapon.should == nil
    end
  end
end