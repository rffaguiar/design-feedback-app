class Admin::UsersController < ApplicationController

  layout 'admin'

  before_action :authenticate_admin!

  def index
    @users = User.order(id: :desc).page(params[:page]).per(10)
  end

  def show
    @user = User.find(params[:id])
  end

  def new
    @user = User.new
  end

  def edit
    @user = User.find(params[:id])
  end

  def update
    @user = User.find(params[:id])

    if @user.update(user_params)
      flash[:success] = 'Usuário Atualizado'
      redirect_to admin_users_path
    else
      render 'edit'
    end
  end

  def create
    @user = User.new(user_params)

    if @user.save
      flash[:notice] = 'Usuário criado com sucesso'
      redirect_to admin_users_path
    else
      render 'new'
    end
  end


  def destroy
    @user = User.find(params[:id])
    @user.destroy

    flash[:notice] = 'Usuário destruido com sucesso'
    redirect_to admin_users_path
  end

  private
    def user_params
      params.require(:user).permit(:name, :email, :address, :password, :password_confirmation)
    end

end
