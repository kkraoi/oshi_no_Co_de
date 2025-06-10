class Public::UsersController < ApplicationController
  def index
    @users = User.all
  end
  
  def show
    @user = User.find(params[:id]);
  end
  
  def edit
    @user = User.find(params[:id]);
  end
  
  def update
    
  end
  
  def destroy
    
  end
  
  def posts
    
  end
  
  private
end
