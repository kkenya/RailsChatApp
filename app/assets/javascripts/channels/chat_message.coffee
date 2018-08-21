jQuery(document).on 'turbolinks:load', ->
  messages = $('#chat_messages')
  if $('#chat_messages').length > 0

    App.chat_message = App.cable.subscriptions.create {
      channel: "ChatMessageChannel",
      chat_room_id: messages.data('room-id')
    },
    connected: ->
      # Called when the subscription is ready for use on the server

    disconnected: ->
      # Called when the subscription has been terminated by the server

    received: (data) ->
      $('#chat_messages').append '<div>' + data['user_name'] + ':' + data['message'] + '</div>'

    speak: (message, room_id) ->
      # フロントのデータをサーバに送信する(サーバー側のメソッド名, 送信するデータ)
      @perform 'speak', message: message, room_id: room_id

    $('#new_chat_message').submit (e) ->
      $this = $(this)
      textarea = $this.find('#chat_message_content')
      if $.trim(textarea.val()).length >= 1
        App.chat_message.speak textarea.val(), messages.data('room-id')
        textarea.val('')
        e.preventDefault()
        return false
#    $(document).on 'keypress', '[data-behavior~=speak_chat_messages]', (event) ->
#    if event.keyCode is 13 #  press Enter key
#      App.chat_message.speak event.target.value
#      event.target.value = ''
#      event.preventDefault()
