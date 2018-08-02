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
    assert_equal 200, status
    assert_select 'li', 4
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
    follow_redirect!
    assert_equal 200, status
    assert_equal "/users/#{User.last.id}", path
    assert flash.present?
  end
end
