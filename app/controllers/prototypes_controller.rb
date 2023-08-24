class PrototypesController < ApplicationController
before_action :move_to_index, except: [:index, :show]
before_action :set_prototype, only: [:edit, :update, :show, :destroy]
  def index
    @prototypes = Prototype.includes(:user)
  end

  def new
    @prototype = Prototype.new
  end

  def create
    @prototype = Prototype.new(prototype_params)
    if @prototype.save
      redirect_to root_path
    else
      render :new, status: :unprocessable_entity
    end
  end

  def edit
    avoid_unexpected_request
  end 

  def update
    # @prototype = Prototype.find(params[:id])
    if @prototype.update(prototype_params)
      redirect_to prototype_path(@prototype.id)
    else
      render "edit"
    end
  end
  
  def show
    
    # @prototype = Prototype.find(params[:id])
    @comment = Comment.new
    @comments = @prototype.comments.includes(:user)
  end

  def destroy
    avoid_unexpected_request
    prototype = Prototype.find(params[:id])
    prototype.destroy    
    redirect_to root_path
  end


  private
  def move_to_index
    unless user_signed_in?
      redirect_to root_path
    end
  end

  def set_prototype
    @prototype = Prototype.find(params[:id])
  end

  def prototype_params
    params.require(:prototype).permit(:title, :catch_copy, :concept, :image).merge(user_id: current_user.id)
  end

  def avoid_unexpected_request
    if current_user != @prototype.user
      redirect_to root_path, alert: "You are not authorized to this action."
    end
  end 
end
