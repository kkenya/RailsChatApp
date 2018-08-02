require 'test_helper'

class SessionsControllerTest < ActionDispatch::IntegrationTest

  def setup
    @user = users(:user1)
  end

  test 'ログインページが表示されること' do
    get login_path
    assert_equal 200, status
    assert_response :success
  end

  test 'ログインが成功し、ユーザーのページに移動すること' do
    post login_path, params: { session: {
      email: @user.email,
      password: 'password'
    } }
    assert_redirected_to @user
    follow_redirect!
    assert_equal 200, status
    assert_equal "/users/#{@user.id}", path
  end
end
