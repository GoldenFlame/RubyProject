require File.dirname(__FILE__) + '/spec_helper.rb'
SimpleCov.start
describe "city" do
  
  before(:each) do
    build :avatar
    build :item_armor
    build :item_weapon
    build :item_armor2
    build :item_weapon2
    build :city
    build :city2

    @monster = @city.fight_areas[0].monsters[0]

    @avatar.city = @city
    @avatar.avatar_items.create(:amount => 1, :item_id => @item_armor.id)
    @avatar.avatar_items.create(:amount => 1, :item_id => @item_weapon.id)
    @avatar.avatar_items.create(:amount => 1, :item_id => @item_armor2.id)
    @avatar.avatar_items.create(:amount => 1, :item_id => @item_weapon2.id)
  end
  describe "rest" do
    it "should restore characters hp and mana to max" do
      @avatar.hp = 0
      @avatar.city.rest(@avatar)
      @avatar.hp.should == @avatar.max_hp
    end
    
    it "should restore characters hp and mana to max" do
      @avatar.mana = 0
      @avatar.city.rest(@avatar)
      @avatar.mana.should == @avatar.max_mana
    end
  end
  describe "arena monster finder" do
    it "should find monster" do
      a = stub("Random", {:rand => 0})
      Random.stub!(:new).and_return(a)
      @avatar.city.find_arena_monster.should == @monster
    end
  end
  
end