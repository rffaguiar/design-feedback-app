class Admin::SpotsController < ApplicationController

  layout 'admin'

  before_action :authenticate_admin!

  def index
    @spots = Spot.order(id: :desc).page(params[:page]).per(10)
  end

  def show
    @spot = Spot.find(params[:id])
  end

  def edit
    @spot = Spot.find(params[:id])
  end

  def update
    @spot = Spot.find(params[:id])
    if @spot.update(spot_params)
      flash[:notice] = 'Spot atualizado com sucesso'
      redirect_to admin_spots_path
    else
      render 'edit'
    end
  end

  def destroy
    @spot = Spot.find(params[:id])
    @spot.destroy

    flash[:notice] = 'Spot deletado com sucesso'
    redirect_to admin_spots_path
  end

  private
    def spot_params
      params.require(:spot).permit(:x_pos, :y_pos)
    end

end
