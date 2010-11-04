require File.dirname(__FILE__) + '/spec_helper.rb'
SimpleCov.start
describe "avatar" do
  before(:all) do
    YamlManage.create_user("test","test") if(!File.exist? "data/user/test.yml")
  end
  
  describe "Initialize" do
    it"should load file when object created" do
      test = Avatar.new('data/user/test.yml')
      test.name.should == 'test'
      test.password.should == 'test'
      test.avatar_class.should == 0
      test.level.should == 1
      test.exp.should == 0
      test.current_city.should == 0
      test.gold.should == 100
      test.base_dmg_min.should == 0
      test.base_dmg_max.should == 0
      test.max_hp.should == 10
      test.hp.should == 10
      test.max_mana.should == 10
      test.mana.should == 10
    end
  end
  
  describe "to hash" do
    it "should convert avatar object to hash" do
      test = Avatar.new('data/user/test.yml')
      hash = test.to_hash
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
    end
  end
  after(:all) do
    File.delete("data/user/test.yml") if File.exists?("data/user/test.yml")
  end
end