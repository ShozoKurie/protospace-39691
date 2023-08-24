class CommentsController < ApplicationController
  before_action :get_prototype, only: :create

  def create
    @comment = Comment.new(comment_params)
    if @comment.save
      redirect_to prototype_path(@prototype.id)
    else
      @comments = @prototype.comments.includes(:user)
      render "prototypes/show"
    end
  end
end

private
  def get_prototype
    @prototype = Prototype.find(params[:prototype_id])
  end
 
  def comment_params
    params.require(:comment).permit(:content).merge(user_id: current_user.id, prototype_id: params[:prototype_id])
  end