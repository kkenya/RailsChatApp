require 'test_helper'

class UsersLoginTest < ActionDispatch::IntegrationTest
  fixtures :users

  def setup
    @user = users(:user1)
  end

  test 'ログイン, ログアウトのリンクがされていること' do
    get root_path
    assert_select 'a[href=?]', login_path, 1
    assert_select 'a[href=?]', logout_path, 0
    user1 = login_as(@user)
    assert_select 'a[href=?]', login_path, 0
    assert_select 'a[href=?]', logout_path, 1
    assert_select 'span#name', user1.name
    assert_select 'span#email', user1.email
    delete logout_path
    assert_redirected_to login_path
    follow_redirect!
  end

  # test 'ユーザー編集、削除のリンクが正しく表示されていること' do
  #   get users_path
  #   assert_select 'a[href=?]', edit_user_path(@user), text: 'Edit', count: 0
  #   assert_select 'a[href=?]', user_path(@user), text: 'Delete', count: 0
  #   user = login_as(@user)
  #   assert_select 'a[href=?]', edit_user_path(user), text: 'Edit', count: 1
  #   assert_select 'a[href=?]', user_path(user), text: 'Delete', count: 1
  # end

  test '未ログイン時editアクションでリダイレクトされること' do
    get edit_user_path(@user)
    assert flash.present?
    assert_redirected_to login_path
  end

  test '未ログイン時updateアクションでリダイレクトされること' do
    patch user_path(@user), params: { user: {
      name: @user.name,
      email: @user.email
    } }
    assert flash.present?
    assert_redirected_to login_path
  end

  test '未ログイン時destroyアクションでリダイレクトされること' do
    assert_no_difference('User.count') do
      delete user_url(@user), params: { user: {
        id: @user.id
      } }
    end
    assert flash.present?
    assert_redirected_to login_path
  end
end
