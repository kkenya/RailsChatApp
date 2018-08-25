require 'test_helper'

class RoomsControllerTest < ActionDispatch::IntegrationTest
  fixtures :users, :rooms

  def setup
    @room = rooms(:one)
    @user = users(:one)
  end

  test 'index.html.erbが表示されること' do
    get rooms_path
    assert_equal 200, status
    assert_equal rooms_path, path
    assert_select 'title', 'チャットルーム一覧 | chat-app'
  end

  test 'show.html.erbが表示されること' do
    login_as(@user)
    get room_path(@room)
    assert_equal 200, status
    assert_equal room_path(@room), path
    assert_select 'title', 'チャットルーム | chat-app'
  end

  test 'new.html.erbが表示されること' do
    login_as(@user)
    get new_room_path
    assert_equal 200, status
    assert_equal new_room_path, path
    assert_select 'title', 'チャットルームの新規作成 | chat-app'
  end

  test '名前が空のときチャットルームの作成が失敗すること' do
    login_as(@user)
    get new_room_path
    assert_no_difference 'Room.count' do
      post rooms_path, params: { room: {
        name: '',
      } }
    end
    assert_select 'ul#error-messages > li', 1
  end

  test 'チャットルームの作成が成功すること' do
    login_as(@user)
    get new_room_path
    assert_difference 'Room.count', 1 do
      post rooms_path, params: { room: {
        name: 'room'
      } }
    end
    assert_response :redirect
    follow_redirect!
    assert_response :success
    assert_equal room_path(Room.last), path
    assert flash.present?
  end
end
