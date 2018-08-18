require 'test_helper'

class RoomsControllerTest < ActionDispatch::IntegrationTest
  fixtures :rooms

  def setup
    @room = rooms(:one)
  end

  test 'index.html.erbが表示されること' do
    get rooms_path
    assert_equal 200, status
    assert_equal rooms_path, path
    assert_select 'title', 'チャットルーム一覧 | chat-app'
  end

  test 'show.html.erbが表示されること' do
    get room_path(@room)
    assert_equal 200, status
    assert_equal room_path(@room), path
    assert_select 'title', 'チャットルーム | chat-app'
  end

  test 'new.html.erbが表示されること' do
    get new_room_path
    assert_equal 200, status
    assert_equal new_room_path, path
    assert_select 'title', 'チャットルームの新規作成 | chat-app'
  end
end
