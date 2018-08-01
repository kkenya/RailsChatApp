class AddReferencesToChatMessages < ActiveRecord::Migration[5.2]
  def change
    add_reference :chat_messages, :room, foreign_key: true
  end
end
