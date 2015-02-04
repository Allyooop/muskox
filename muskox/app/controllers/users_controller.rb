class UsersController < ApplicationController
  #   string :first_name
  #   string :last_name
  #   string :organization
  #   text :biography
  #   string :job_title
  #   string :email
  

  def index
    @users = User.all
  end

  def show
    @user = User.find(params[:id])
  end
  
  def create
    @user = User.new(article_params)
    
    @user.save
    redirect_to @user
  end
  
  private
  def article_params
    params.require(:article).permit(:first_name, :last_name, :organization, :biography, :job_title, :email)
  end
  
end
