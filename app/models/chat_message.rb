# frozen_string_literal: true

class ChatMessage < ApplicationRecord
  belongs_to :user
  belongs_to :room

  validates :content, presence: true, length: { maximum: 100 }

  # after_create_commit do
  #   ChatMessageBroadcastJob.perform_later self
  # end

  def user_name
    return '名無しさん' if user_id.blank?
    user.name
  end

  def timestamp
    created_at.strftime('%H:%M:%S %d %B %Y')
  end
end
