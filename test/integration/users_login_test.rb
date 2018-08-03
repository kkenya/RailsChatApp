require 'test_helper'

class UsersLoginTest < ActionDispatch::IntegrationTest
  fixtures :users

  test 'ログイン後にログアウトのリンクが表示されていること' do
    user1 = login(users(:user1))
    assert_select 'a[href=?]', logout_path
    assert_select 'span#name', user1.name
    assert_select 'span#email', user1.email
    delete logout_path
    assert_redirected_to login_path
    follow_redirect!
  end

  private

  def login(who)
    post login_path, params: { session: { email: who.email, password: 'password' } }
    assert_redirected_to who
    follow_redirect!
    assert_equal user_path(who), path
    who
  end
end
