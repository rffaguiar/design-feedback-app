class Admin::DesignsController < ApplicationController
  layout 'admin'
  before_action :authenticate_admin!

  def index
    @images = Design.order(id: :desc).page(params[:page]).per(10)
  end

  def show
    @image = Design.find(params[:id])
  end

  def edit
    @image = Design.find(params[:id])
  end

  def update
    @image = Design.find(params[:id])

    if @image.update(image_params)
      flash[:notice] = 'Imagem atualizada com sucesso'
      redirect_to admin_designs_path
    else
      render 'edit'
    end
  end

  def destroy
    @image = Design.find(params[:id])
    @image.destroy

    flash[:notice] = 'Imagem deletada com sucesso'
    redirect_to admin_designs_path
  end

  private

    def image_params
      params.require(:design).permit(:title, :subtitle, :link, :image_path, :image_thumb_path )
    end

end
