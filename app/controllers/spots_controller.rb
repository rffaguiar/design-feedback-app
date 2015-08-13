class SpotsController < ApplicationController
  before_action :authenticate_user!, only: [:delete]
  before_action :allowed_user, only: [:delete]

  # Ajax
  # Destroy the spot and its comments
  # Params (through rails params):
  # +spot_id+:: <Integer>
  # Returns
  # trigger js 'comments/spot_delete'
  def delete
    return false if params[:spot_id].nil?

    if Spot.exists?(params[:spot_id])
      @spot = Spot.find(params[:spot_id])
      @spot.destroy
    else
      return false
    end
    respond_to do |format|
      format.js { render template: 'comments/spot_delete' }
      format.html { redirect_to :back }
    end
  end

  private

    # only allow users that are spot owners
    def allowed_user
      unless current_user.id == Spot.find(params[:spot_id]).user.id
        flash[:notice] = 'Voce não tem permissão para fazer isso!'
        redirect_to root_url
      end
    end
end
