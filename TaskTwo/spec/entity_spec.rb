require File.dirname(__FILE__) + '/spec_helper.rb'
SimpleCov.start
describe "Initialize" do
  it"should load file when object created" do
  test = Entity.new('data/item/sword1.yml')
  test.name.should == 'Wooden sword'
  end
end