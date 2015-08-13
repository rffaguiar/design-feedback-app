class CommentsController < ApplicationController

    before_action :authenticate_user!, only: [:create, :delete]
    before_action :allowed_user, only: [:delete]

    # Ajax
    # Create a comment in a design. If the spot doesnt exist, a spot and a comment is created. If the spot exists, the comment is created for this spot
    def create

      # params['spot-id'] is not necessary
      # params['design-y-pos'] and params['design-x-pos'] are necessary only if params['spot-id'] is absent

      spot_id = params['spot-id']
      design_id = params['design-id']
      design_comment = params['design-comment-text']

      head :unprocessable_entity and return if design_id.blank? || design_comment.blank?

      if spot_id.present?
        # p 'creating a comment in an existing spot'
        exist_spot = true
        new_spot = false

        @spot = Spot.find(spot_id)
        @comment = @spot.comments.build comment: design_comment, design_id: design_id, user_id: current_user.id
      else
        # p 'creating a comment AND a spot'
        exist_spot = false
        new_spot = true
        @spot = Spot.new x_pos: params['design-x-pos'], y_pos: params['design-y-pos'], design_id: design_id, user_id: current_user.id
        if @spot.valid?
          error_spot = false
          @comment = @spot.comments.build comment: design_comment, design_id: design_id, user_id: current_user.id
        else
          # p @spot.errors
          error_spot = true
        end
      end

      respond_to do |format|
        if error_spot
          format.js { head :unprocessable_entity and return }
          format.html { redirect_to root_path, notice: 'algum erro no comentário/spot' }
        elsif new_spot && @spot.save
          unless @comment.design.user.id == @comment.user.id
            CommentMailer.new_comment(@comment).deliver_now
          end
          format.js { render template: 'comments/brand_new' and return }
          format.html { redirect_to root_path, notice: 'comentário criado com sucesso' }
        elsif exist_spot && @spot.save
          unless @comment.design.user.id == @comment.user.id
            CommentMailer.new_comment(@comment).deliver_now
          end
          format.js { render template: 'comments/existing' and return }
          format.html { redirect_to root_path, notice: 'comentário criado com sucesso' }
        else
          format.js { head :unprocessable_entity and return }
          format.html { redirect_to root_path, notice: 'algum erro no comentário' }
        end
      end
      # p 'should never get here'
    end

    # Ajax
    # Delete a comment or a spot (and its comments)
    def delete
      spot_destroyed = false
      if Comment.exists?(params[:comment_id])
        @comment = Comment.find(params[:comment_id])
        @spot = @comment.spot
        # verify if this is the last/unique comment remaining
        # if yes, then need to delete the spot too
        if @spot.comments.count <= 1
          @spot.destroy
          spot_destroyed = true
        else
          @comment.destroy
        end
      end

      respond_to do |format|
        if spot_destroyed
          format.js { render template: 'comments/spot_delete' and return }
          format.html { redirect_to :back }
        else
          format.js { render template: 'comments/comment_delete' and return }
          format.html { redirect_to :back }
        end
      end
    end

    private

      # just the design/comment owner can delete the comment
      def allowed_user
        redirect_to root_url and return if !user_signed_in? || params[:comment_id].blank?

        if Comment.exists?(params[:comment_id])
          comment = Comment.find(params[:comment_id])
          comment_owner = current_user.comments.exists?(comment.id)
          design_owner =  current_user.designs.exists?(comment.design.id)
          unless comment_owner || design_owner
            p "be careful, user isn\'t design/comment owner and is trying to delete the comment -> user_id: #{current_user.id}"
            redirect_to root_url
          end
        else
          redirect_to root_url
        end
      end

end
