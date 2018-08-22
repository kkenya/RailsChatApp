# frozen_string_literal: true

class ChatMessageBroadcastJob < ApplicationJob
  queue_as :default

  def perform(chat_message)
    ActionCable.server.broadcast(
      "chat_messages_#{chat_message.room.id}_channel",
      chat_message: render_chat_message(chat_message)
    )
  end

  private

  def render_chat_message(chat_message)
    ChatMessagesController.render(
      partial: 'chat_messages/chat_message',
      locals: { chat_message: chat_message }
    )
  end
end
