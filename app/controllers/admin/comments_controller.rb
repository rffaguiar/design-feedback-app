class Admin::CommentsController < ApplicationController
  layout 'admin'
  before_action :authenticate_admin!

  def index
    @comments = Comment.order(id: :desc).page(params[:page]).per(10)
  end

  def show
    @comment = Comment.find(params[:id])
  end

  def new
  end

  def edit
    @comment = Comment.find(params[:id])
  end

  def update
    @comment = Comment.find(params[:id])

    if @comment.update(comment_params)
      flash[:notice] = 'Comentário atualizado com sucesso'
      redirect_to admin_comments_path
    else
      render 'edit'
    end
  end

  def destroy
    if Comment.exists?(params[:id])
      @comment = Comment.find(params[:id])
      @spot = @comment.spot
      # verify if this is the last comment
      if @spot.comments.count <= 1
        flash[:notice] = 'Comentário e seu Spot deletado com sucesso'
        @spot.destroy
      else
        flash[:notice] = 'Comentário deletado com sucesso'
        @comment.destroy
      end
    else
      p 'comentário não existe'
    end
    redirect_to admin_comments_path
  end

  private
    def comment_params
      params.require(:comment).permit(:comment)
    end

end
