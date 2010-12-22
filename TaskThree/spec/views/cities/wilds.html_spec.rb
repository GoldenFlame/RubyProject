require 'spec_helper.rb'

describe "cities/wilds.html.erb" do
  before(:each) do
    build :avatar
    build :item_armor
    build :item_weapon
    build :item_armor2
    build :item_weapon2
    build :city
    build :city2

    @monster = @city.fight_areas[0].monsters[0]
    session[:user_id] = @avatar.id
    @avatar.city = @city
    @avatar.avatar_items.create(:amount => 1, :item_id => @item_armor.id)
    @avatar.avatar_items.create(:amount => 1, :item_id => @item_weapon.id)
    @avatar.avatar_items.create(:amount => 1, :item_id => @item_armor2.id)
    @avatar.avatar_items.create(:amount => 1, :item_id => @item_weapon2.id)
  end
  it "should displays all wilds in city" do
    assign(:wilds, @avatar.city.fight_areas)
    render
    rendered.should include("#{@city.fight_areas[0].name}")
  end
  
  
  it "should display links to wilds" do
    assign(:wilds, @avatar.city.fight_areas)
    render
    rendered.should include("<a href")
  end
end