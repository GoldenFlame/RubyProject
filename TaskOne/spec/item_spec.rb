require File.dirname(__FILE__) + '/spec_helper.rb'
SimpleCov.start
describe "Initialize" do
  it"should load file when object created" do
    test = Item.new('data/item/sword1.yml')
    test.name.should == 'Wooden sword'
    test.item_class.should == 'sword'
    test.level.should == 1
    test.damage_min.should == 10
    test.damage_max.should == 20
    test.price.should == 10
  end
end