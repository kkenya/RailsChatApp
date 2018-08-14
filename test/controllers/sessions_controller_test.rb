require 'test_helper'

class SessionsControllerTest < ActionDispatch::IntegrationTest
  fixtures :users

  def setup
    @user = users(:user1)
  end

  test 'ログインページが表示されること' do
    get login_path
    assert_equal 200, status
    assert_equal login_path, path
      assert_select 'title', 'ログイン | chat-app'
  end

  test 'ログインが失敗すること' do
    post login_path, params: { session: {
      email: '',
      password: ''
    } }
    assert_equal 200, status
    assert_equal '/login', path
    assert flash.present?
    get root_path
    assert flash.empty?
  end

  test 'ログインが成功し、ユーザーのページに移動すること' do
    post login_path, params: { session: {
      email: @user.email,
      password: 'password'
    } }
    assert_redirected_to @user
    follow_redirect!
    assert_equal 200, status
    assert_equal user_path(@user), path
  end

end
