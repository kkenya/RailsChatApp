class AddColumnToChatMessage < ActiveRecord::Migration[5.2]
  def change
    add_reference :chat_messages, :user, foreign_key: true
  end
end
