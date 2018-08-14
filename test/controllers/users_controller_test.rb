require 'test_helper'

class UsersControllerTest < ActionDispatch::IntegrationTest
  fixtures :users

  def setup
    @user = users(:user1)
  end

  test 'ユーザー一覧ページが表示されること' do
    get users_path
    assert_equal 200, status
    assert_equal users_path, path
    assert_select 'title', 'ユーザー一覧 | chat-app'
  end

  test 'ユーザー情報ページが表示されること' do
    get user_path(@user)
    assert_equal 200, status
    assert_equal user_path(@user), path
    assert_select 'title', 'ユーザー情報 | chat-app'
  end
  test 'ユーザー更新ページが表示されること' do
    get edit_user_path(@user)
    assert_equal 200, status
    assert_equal edit_user_path(@user), path
    assert_select 'title', 'ユーザー情報の編集 | chat-app'
  end

end
