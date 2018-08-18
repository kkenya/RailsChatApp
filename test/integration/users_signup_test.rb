require 'test_helper'

class UsersSignupTest < ActionDispatch::IntegrationTest

  test 'ユーザーの登録ページが表示されること' do
    get signup_path
    assert_equal 200, status
  end

  test '無効なユーザー登録が失敗すること' do
    get signup_path
    assert_no_difference 'User.count' do
      post users_path, params: { user: {
        name: '',
        email: 'user@invalid',
        password: 'foo',
        password_confirmation: 'bar'
      } }
    end
    assert_equal users_path, path
    assert_select 'ul#error-messages > li', 4
  end

  test 'パスワードが空のときユーザー登録が失敗すること' do
    get signup_path
    assert_no_difference 'User.count', 1 do
      post users_path, params: { user: {
        name: 'user',
        email: 'user@example.com',
        password: '',
        password_confirmation: ''
      }}
    end
    assert_response :success
    assert_equal users_path, path
    assert_select 'ul#error-messages > li', 1
  end

  test 'ユーザー登録が成功すること' do
    get signup_path
    assert_difference 'User.count', 1 do
      post users_path, params: { user: {
        name: 'user',
        email: 'user@example.com',
        password: 'password',
        password_confirmation: 'password'
      }}
    end
    assert_response :redirect
    follow_redirect!
    assert_response :success
    assert_equal user_path(User.last), path
    assert flash.present?
  end
end
