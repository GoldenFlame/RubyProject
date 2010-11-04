require File.dirname(__FILE__) + '/spec_helper.rb'
require File.dirname(__FILE__) + '/../matchers/be_readable.rb'
require File.dirname(__FILE__) + '/../matchers/be_updated.rb'

RSpec.configure do |config|  
  config.include(Matchers)  
end

describe "Yaml File system" do
  describe "create char" do
    it "should create character file with basic info and stats" do
      YamlManage.create_user("test", "test")
      (File.exist?"data/user/test.yml").should == true
    end
  end
    
  describe "load any game file" do
    it "should load any game file and return it" do
      YamlManage.load_file("data/user/test.yml").should be_readable
    end
  end
    
  describe "update char" do
    it "should update character file with current info" do
      before = YamlManage.load_file("data/user/test.yml")
      test2 = {:name => 'test',
        :password => 'test',
        :class => 2,
        :level => 10,
        :exp => 1000,
        :current_city => 1,
        :gold => 13200};
      YamlManage.save_char(test2)
      YamlManage.load_file("data/user/test.yml").should be_updated(before)
    end
  end
  
  after(:all) do
    File.delete("data/user/test.yml") if File.exists?("data/user/test.yml")
  end
end