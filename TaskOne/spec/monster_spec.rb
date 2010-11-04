require File.dirname(__FILE__) + '/spec_helper.rb'
SimpleCov.start
describe "Initialize" do
  it"should load file when object created" do
    test = Monster.new('data/monster/Sin.yml')
    test.name.should == 'Sin'
    test.level.should == 1
    test.base_dmg_min.should == 10
    test.base_dmg_max.should == 30
    test.max_hp.should == 75
    test.hp.should == 75
    test.exp_bonus.should == 30
    test.gold_max.should == 100
  end
end