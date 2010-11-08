require File.dirname(__FILE__) + '/spec_helper.rb'
SimpleCov.start
describe "avatar" do
  before(:all) do
    YamlManage.create_user("test","test") if(!File.exist? "data/user/test.yml")
  end
  
  before(:each) do
    @test = Avatar.new('data/user/test.yml')
  end
  
  describe "Initialize" do
    it"should load file when object created" do
      @test.name.should == 'test'
      @test.password.should == 'test'
      @test.avatar_class.should == 0
      @test.level.should == 1
      @test.exp.should == 0
      @test.current_city.should == 0
      @test.gold.should == 100
      @test.base_dmg_min.should == 0
      @test.base_dmg_max.should == 0
      @test.max_hp.should == 10
      @test.hp.should == 10
      @test.max_mana.should == 10
      @test.mana.should == 10
    end
  end
  
  describe "equipment initialization" do
    it"should load item Wooden sword and no armor" do
      weapon, armor = @test.equipment_init('Wooden sword', nil)
      weapon.name.should == 'Wooden sword'
      armor.should == nil
    end
    
    it"should not load any items" do
      weapon, armor = @test.equipment_init(nil, nil)
      weapon.should == nil
      armor.should == nil
    end
  end
  
  describe "equip" do
    it"should equip item wooden sword" do
      item = Item.new("data/item/sword1.yml")
      @test.eq_weapon = nil
      @test.equip(item)
      @test.eq_weapon.name.should == 'Wooden sword'
    end
    
    it"should put equiped item into backpack and equip wooden sword" do
      sword = Item.new("data/item/sword1.yml")
      bow = Item.new("data/item/bow1.yml")
      @test.eq_weapon = bow
      @test.equip(sword)
      @test.eq_weapon.name.should == 'Wooden sword'
      @test.backpack.should include(bow)
    end
  end
  
  describe "disequip" do
    it"should disequip Wooden sword" do
      item = Item.new("data/item/sword1.yml")
      @test.equip(item)
      @test.eq_weapon.name.should == 'Wooden sword'
      @test.disequip(item)
      @test.eq_weapon.should == nil
    end
  end
  
  describe "to hash" do
    it "should convert avatar object to hash" do
      @test.eq_weapon = Item.new("data/item/sword1.yml")
      hash = @test.to_hash
      hash[:name].should == 'test'
      hash[:password].should == 'test'
      hash[:class].should == 0
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