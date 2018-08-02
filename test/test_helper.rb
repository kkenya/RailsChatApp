# frozen_string_literal: true

ENV['RAILS_ENV'] ||= 'test'
require_relative '../config/environment'
require 'rails/test_help'

class ActiveSupport::TestCase

  fixtures :all

  # テストユーザーがログイン中の場合にtrueを返す
  # def test_user_logged_in?
  #   !session[:user_id].nil?
  # end
end
