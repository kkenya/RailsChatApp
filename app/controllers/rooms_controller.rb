class RoomsController < ApplicationController
  before_action :logged_in_user, only: [:new, :create, :show]
  def index
    @rooms = Room.all
  end

  def show
    @room = Room.find(params[:id])
  end

  def new
    @room = Room.new
  end

  def create
    @room = Room.new(room_params)

    if @room.save
      flash[:success] = 'ルームが作成されました'
      redirect_to @room
    else
      render 'new'
    end
  end

  def room_params
    params.require(:room).permit(:name)
  end
end
