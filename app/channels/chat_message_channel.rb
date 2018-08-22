# frozen_string_literal: true

class ChatMessageChannel < ApplicationCable::Channel
  # コンシューマーがこのチャンネルのサブスクライバ側になったとき
  def subscribed
    stream_from "chat_messages_#{params['room_id']}_channel"
  end

  def unsubscribed
    # Any cleanup needed when channel is unsubscribed
  end

  # @perform 'speak'で発火する
  def speak(data)
    current_user.chat_messages.create! content: data['chat_message'], room_id: data['room_id']
  end
end
