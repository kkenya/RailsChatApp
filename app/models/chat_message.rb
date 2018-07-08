# frozen_string_literal: true

class ChatMessage < ApplicationRecord
  after_create_commit do
    ChatMessageBroadcastJob.perform_later self
  end
end
