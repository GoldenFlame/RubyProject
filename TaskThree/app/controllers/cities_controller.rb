class CitiesController < ApplicationController

  def wilds
    @wilds = @user.city.fight_areas
    
  end

  def inn
    @user.city.rest(@user)
  end
  
end
