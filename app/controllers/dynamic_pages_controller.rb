class DynamicPagesController < ApplicationController
  before_action :authenticate_user!, only: [:projetos, :individuais, :my_comments]

  # get all projects that belongs to current user
  # not implemented yet
  def projetos
  end

  # get all singles that belongs to current user
  def individuais
    @singles = current_user.designs.reverse_order.page(params[:page]).per(15)
  end

  # get only singles commented by current user
  def my_comments
    @singles = Design.joins(:comments).uniq.where('comments.user_id = :user_id', user_id: current_user.id)
  end
end
