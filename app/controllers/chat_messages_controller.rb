# frozen_string_literal: true

class ChatMessagesController < ApplicationController
  before_action :logged_in_user, only: [:index]

  def index
    @room = Room.find(params[:room_id])
    @chat_messages = ChatMessage.all
    @chat_message = ChatMessage.new
  end
end
