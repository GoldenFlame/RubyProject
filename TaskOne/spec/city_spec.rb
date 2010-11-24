require File.dirname(__FILE__) + '/spec_helper.rb'
SimpleCov.start
describe "Initialize" do
  it"should load file when object created" do
    expected = {:name => 'Ellion',
      :shop => 'Run Down Shop',
      :inn => 'Wild Legs Inn',
      :fight_area_nr => 1}
    City.new('data/city/Ellion.yml').should be_loaded_with(expected)
    
  end
end