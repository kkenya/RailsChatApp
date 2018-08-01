class RenameBodyColumnToChatMessages < ActiveRecord::Migration[5.2]
  def change
    rename_column :chat_messages, :body, :content
  end
end
