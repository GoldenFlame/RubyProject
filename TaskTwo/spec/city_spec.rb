require File.dirname(__FILE__) + '/spec_helper.rb'
SimpleCov.start
describe "Initialize" do
  it"should load file when object created" do
    test = City.new('data/city/Ellion.yml')
    test.name.should == 'Ellion'
    test.shop.should == 'Run Down Shop'
    test.inn.should == 'Wild Legs Inn'
    test.fight_area_nr.should == 1
  end
end