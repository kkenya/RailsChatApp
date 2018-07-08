class CreateChatMassages < ActiveRecord::Migration[5.2]
  def change
    create_table :chat_massages do |t|
      t.integer :user_id
      t.text :body

      t.timestamps
    end
  end
end
