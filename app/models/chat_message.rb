# frozen_string_literal: true

class ChatMessage < ApplicationRecord
  belongs_to :user
  belongs_to :room

  validates :content, presence: true, length: { maximum: 100 }

  after_create_commit { ChatMessageBroadcastJob.perform_later self }

  def timestamp
    created_at.strftime('%H:%M:%S %d %B %Y')
  end
end
