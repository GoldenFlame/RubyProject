File.dirname(__FILE__) + '/spec_helper.rb'
SimpleCov.start
RSpec.configure do |config|  
  config.include(Matchers)  
end
describe "Initialize" do
  before(:all) do
    YamlManage.create_user("test","test") if(!File.exist? "data/user/test.yml")
  end
  before(:each) do
    @avatar = Avatar.new('data/user/test.yml')
    @monster = Monster.new("data/monster/Sin.yml")
  end
  
  it"should load file when object created" do
    expected = {:name => 'Sin',
      :level => 1, 
      :base_dmg_min => 10, 
      :base_dmg_max => 30, 
      :max_hp => 75,
      :hp => 75,
      :exp_bonus => 30,
      :gold_max => 100}
    Monster.new('data/monster/Sin.yml').should be_loaded_with(expected)
  end
  
  describe "Attack" do
    it "should decrease avatars health points by 10 when avatar has no armor" do
      a = mock("Random", {:rand => 10})
      Random.stub!(:new).and_return(a)
      @avatar.hp = 100
      @monster.attack(@avatar)
      @avatar.hp.should == 90
    end
        
    it "should decrease avatars health points by 48 when avatar has armor" do
      a = mock("Random", {:rand => 50})
      Random.stub!(:new).and_return(a)
      @avatar.hp = 100
      @avatar.equip(Item.new("data/item/armor1.yml"))
      @monster.attack(@avatar)
      @avatar.hp.should == 52
    end
  end  
end