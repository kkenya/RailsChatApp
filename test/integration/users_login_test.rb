require 'test_helper'

class UsersLoginTest < ActionDispatch::IntegrationTest
  test 'ログインが失敗すること' do
  get login_path
  assert_equal '/login', path
  post login_path, params: { session: { email: '', password: '' } }
  assert_equal '/login', path
  assert flash.present?
  get root_path
  assert flash.empty?
  end
end
