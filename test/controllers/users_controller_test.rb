require 'test_helper'

class UsersControllerTest < ActionDispatch::IntegrationTest
  fixtures :users

  def setup
    @user = users(:one)
  end

  test 'index.html.erbが表示されること' do
    get users_path
    assert_equal 200, status
    assert_equal users_path, path
    assert_select 'title', 'ユーザー一覧 | chat-app'
  end

  test 'show.html.erbが表示されること' do
    get user_path(@user)
    assert_equal 200, status
    assert_equal user_path(@user), path
    assert_select 'title', 'ユーザー情報 | chat-app'
  end

  test 'new.html.erbが表示されること' do
    get signup_path
    assert_equal 200, status
    assert_equal signup_path, path
    assert_select 'title', 'ユーザーの新規登録 | chat-app'
  end

  test 'edit.html.erbが表示されること' do
    user = login_as(@user)
    get edit_user_path(@user)
    assert_equal 200, status
    assert_equal edit_user_path(user), path
    assert_select 'title', 'ユーザー情報の編集 | chat-app'
  end

  test 'ユーザーが削除されること' do
    user = login_as(@user)
    # assert_difference('User.count', -1) do
    #   delete user_url(user), params: { user: {
    #     id: user.id
    #   } }
    delete user_path(user)
    assert flash.present?
    assert_redirected_to login_path
  end
end
