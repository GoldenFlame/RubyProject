require File.dirname(__FILE__) + '/spec_helper.rb'

describe "Yaml File system" do
  describe "create char" do
    it "should create character file with basic info and stats" do
      YamlManage.create_user("test", "test")
      (File.exist?"data/user/test.yml").should == true
    end
  end
    
  describe "load any game file" do
    it "should load user game file" do
      expected = {:name => "test", :level => 1}
      YamlManage.load_file("data/user/test.yml").should have_hash_values(expected)  
    end
    
    it "should load item file" do
      expected = {:name => 'Simple sword', :level => 5}
      YamlManage.load_file("data/item/sword2.yml").should have_hash_values(expected)  
    end
    
    it "should load monster file" do
      expected = {:name => 'Sin', :level => 1}
      YamlManage.load_file("data/monster/sin.yml").should have_hash_values(expected)  
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
      YamlManage.load_file("data/user/test.yml").should_not == before
    end
  end
  
  after(:all) do
    File.delete("data/user/test.yml") if File.exists?("data/user/test.yml")
  end
end