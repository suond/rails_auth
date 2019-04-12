class CatsController < ApplicationController
  before_action :ensure_logged_in, only: [:new, :create, :edit, :update, :destroy]

  def index
    @cats = Cat.all
    render :index
  end

  def show
    @cat = Cat.find(params[:id])
    render :show
  end

  def new
    @cat = Cat.new
    render :new
  end

  def create
    @cat = Cat.new(cat_params)
    @cat.owner = current_user
    if @cat.save
      redirect_to cat_url(@cat)
    else
      flash.now[:errors] = @cat.errors.full_messages
      render :new
    end
  end

  def edit
    @cat = current_user.cats.find_by(user_id: current_user.id)
    if @cat.nil?
      flash[:errors] =["Can't edit a cat that's not your"]
      redirect_to cats_url
    else
      render :edit
    end
  end

  def update
    @cat = Cat.find(params[:id])
    if @cat.owner == current_user && @cat.update_attributes(cat_params)
      redirect_to cat_url(@cat)
    else
      flash.now[:errors] = [@cat.errors.full_messages, "No haxes for you dude"]
      render :edit
    end
  end

  private

  def cat_params
    params.require(:cat).permit(:age, :birth_date, :color, :description, :name, :sex)
  end
end
