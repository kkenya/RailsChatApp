# frozen_string_literal: true

module ApplicationCable
  class Connection < ActionCable::Connection::Base
    # 接続ID
    identified_by :current_user

    # ユーザーがログインしていた場合、接続を確立する
    def connect
      self.current_user = find_verified_user
      # logger.add_tags 'ActionCable', current_user.name
    end

    # protected
    private

    # ユーザーがログインしていた場合、ユーザーのインスタンを返す
    def find_verified_user
      if verified_user = User.find_by(id: cookies.signed[:user_id])
        verified_user
      else
        reject_unauthorized_connection
      end
    end
  end
end
