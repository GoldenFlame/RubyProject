require File.dirname(__FILE__) + '/spec_helper.rb'
SimpleCov.start
describe "item" do
  describe "Initialize" do
    it"should load file when object created" do
      expected = {:name => 'Wooden sword',
      :item_class => 'sword',
      :level => 1,
      :damage_min => 10,
      :damage_max => 20,
      :price => 10}
      Item.new('data/item/sword1.yml').should be_loaded_with(expected)
    end
  end
  describe "item filename finder" do
    it "should find 'Wooden sword' filename" do
      Item.find_file_name("Wooden sword").should == "sword1"
    end
  end
end