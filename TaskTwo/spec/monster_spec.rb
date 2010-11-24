require File.dirname(__FILE__) + '/spec_helper.rb'
SimpleCov.start


describe "attack" do
  before(:each) do
    build :avatar
    build :city
    build :item_armor
    @monster = @city.fight_areas[0].monsters[0]
    @avatar.avatar_items.create(:amount => 1, :item_id => @item_armor.id)
    @avatar.backpack_init
  end

  it "should decrease avatars health points by 10 when avatar has no armor" do
    a = mock("Random", {:rand => 10})
    Random.stub!(:new).and_return(a)
    @avatar.hp = 100
    @monster.attack(@avatar)
    @avatar.hp.should == 90
  end
      
  it "should decrease avatars health points by 48 when avatar has armor" do
    a = mock("Random", {:rand => 50})
    Random.stub!(:new).and_return(a)
    @avatar.hp = 100
        
    @avatar.eq_armor = @item_armor
    @monster.attack(@avatar)
    @avatar.hp.should == 52
  end
end
    