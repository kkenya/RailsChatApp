class RoomsController < ApplicationController
  before_action :logged_in_user, only: [:new, :create, :show]

  def index
    @rooms = Room.all
  end

  def show
    @room = Room.includes([:chat_messages, :users]).find(params[:id])
    @chat_message = ChatMessage.new
  end

  def new
    @room = Room.new
  end

  def create
    @room = current_user.rooms.build(room_params)

    if @room.save
      flash[:success] = 'ルームが作成されました'
      redirect_to @room
    else
      render 'new'
    end
  end

  private

  def room_params
    params.require(:room).permit(:name)
  end
end
