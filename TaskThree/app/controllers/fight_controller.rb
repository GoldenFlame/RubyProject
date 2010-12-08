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
    if(@user.fight == nil)
      if(params[:area])
        area = FightArea.find(params[:area])
        monster = area.monsters[Random.new.rand(0..area.monsters.size-1)]
      else
        monster = @user.city.find_arena_monster
      end
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
  
  def user_action
    if params[:attack]
      dmg = @user.attack(@user.fight.monster)
      @user.fight.monster_hp -= dmg
      @user.fight.save
      redirect_to :action => 'check_fight_end'
    elsif params[:skill_attack]
      dmg = @user.skill_attack(@user.fight.monster)
      @user.fight.monster_hp -= dmg
      @user.fight.save
      redirect_to :action => 'check_fight_end'
    elsif params[:heal]
      @user.heal
      redirect_to :action => 'check_fight_end'    
    elsif params[:back]
      if(@user.fight != nil)
        @user.fight.destroy  
      end
      redirect_to :controller => 'user', :action => 'private'
    end
    @user.fight.monster.attack(@user)
  end

end
