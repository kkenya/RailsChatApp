require 'test_helper'

class UsersEditTest < ActionDispatch::IntegrationTest
  fixtures :users

  def setup
    @user = users(:one)
  end

  test 'ユーザー情報の更新が失敗すること' do
    user = login_as(@user)
    get edit_user_path(user)
    patch user_path(user), params: { user: {
      name: 'user1.1',
      email: 'user1.1@example.com',
      password: 'foo',
      password_confirmation: 'bar'
    } }
    assert flash.empty?
  end

  test 'ユーザー情報の更新が成功すること' do
    user = login_as(@user)
    get edit_user_path(user)
    name = 'user1.1'
    email = 'user1.1@example.com'
    patch user_path(user), params: { user: {
      name: name,
      email: email,
      password: '',
      password_confirmation: ''
    } }
    assert_not flash.empty?
    assert_redirected_to user
    @user.reload
    assert_equal name, user.name
    assert_equal email, user.email
  end
end
