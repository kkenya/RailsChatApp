# frozen_string_literal: true

ENV['RAILS_ENV'] ||= 'test'
require_relative '../config/environment'
require 'rails/test_help'

class ActiveSupport::TestCase

  fixtures :all

  private

  def login_as(who)
    post login_path, params: { session: { email: who.email, password: 'password' } }
    assert_redirected_to who
    follow_redirect!
    assert_equal user_path(who), path
    who
  end
end
