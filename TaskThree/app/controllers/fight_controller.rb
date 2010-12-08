class FightController < ApplicationController
  protect_from_forgery
  before_filter :user
  
  def user
    @user = Avatar.find(session[:user_id])
  end
  
  def check_fight_end
    if(@user.fight.check_fight_end(@user, @user.fight.monster))
      @user.fight.ended = true
      @user.fight.save
    end 
    redirect_to :action => "area", :area => @user.fight.fight_area_id
  end
  
  def area
    if(params[:arena])
      
    end
    if(@user.fight == nil)
      area = FightArea.find(params[:area])
      monster = area.monsters[Random.new.rand(0..area.monsters.size-1)]
      @user.create_fight(:monster_id => monster.id, 
      :monster_hp => monster.max_hp,
      :ended => false,
      :fight_area_id => params[:area])
    else
      if(@user.fight.ended == true)
        if(@user.hp > 0)
          flash[:notice] = "Fight ended. You are victorious."
        else
          flash[:notice] = "Fight ended. You were defeated."
        end
      end
    end
  end
  
  def attack
    dmg = @user.attack(@user.fight.monster)
    @monster = @user.fight.monster_hp
    @user.fight.monster_hp -= dmg
    @user.fight.save
    redirect_to :action => 'check_fight_end'
  end
  
  def skill
    dmg = @user.skill_attack(@user.fight.monster)
    @user.fight.monster_hp -= dmg
    redirect_to :action => 'check_fight_end'
  end
  
  def heal
    @user.heal
    redirect_to :action => "area/#{params[:area]}"
  end
end
