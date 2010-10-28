require 'simplecov'
SimpleCov.start
require File.dirname(__FILE__) + '/matchers/be_readable.rb'
require File.dirname(__FILE__) + '/matchers/be_updated.rb'
require File.dirname(__FILE__) + '/yaml_manage.rb'

RSpec.configure do |config|  
  config.include(Matchers)  
end

describe "Yaml File system" do
  describe "create char" do
    it "should create character file with basic info and stats" do
      YamlManage.create_char("SpecTest", "test")
      (File.exist?"data/user/SpecTest.yml").should == true
    end
  end
    
  describe "load any game file" do
    it "should load any game file and return it" do
      YamlManage.load_file("data/user/SpecTest.yml").should be_readable
    end
  end
    
  describe "update char" do
    it "should update character file with current info" do
      before = YamlManage.load_file("data/user/SpecTest.yml")
      SpecTest = {:name => 'SpecTest',
        :password => 'test',
        :class => 2,
        :level => 10,
        :exp => 1000,
        :current_city => 1,
        :gold => 13200};
      YamlManage.save_char(SpecTest)
      YamlManage.load_file("data/user/SpecTest.yml").should be_updated(before)
    end
  end
  after(:all) do
    File.delete("data/user/SpecTest.yml") if File.exists?("data/user/SpecTest.yml")
  end
end