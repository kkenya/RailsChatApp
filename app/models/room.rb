class Room < ApplicationRecord
  has_many :room_members
  has_many :users, through: :room_members
  has_many :chat_messages, dependent: :destroy

  validates :name, presence: true, length: { maximum: 255 }
end
