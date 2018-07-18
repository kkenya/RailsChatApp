# frozen_string_literal: true

class ChatMessage < ApplicationRecord
  after_create_commit do
    ChatMessageBroadcastJob.perform_later self
  end

  belongs_to :user
  belongs_to :room

  def user_name
    return '名無しさん' if user_id.blank?
    user.name
  end
end
