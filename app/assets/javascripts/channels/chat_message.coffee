jQuery(document).on 'turbolinks:load', ->
  chat_messages = $('#chat_messages')
  if $('#chat_messages').length > 0

    App.chat_message = App.cable.subscriptions.create {
      channel: "ChatMessageChannel",
      room_id: chat_messages.data('room-id')
    },
    connected: ->
      # Called when the subscription is ready for use on the server

    disconnected: ->
      # Called when the subscription has been terminated by the server

    received: (data) ->
      $('#chat_messages').append data['chat_message']

    speak: (chat_message, room_id) ->
      # フロントのデータをサーバに送信する(サーバー側のメソッド名, 送信するデータ)
      @perform 'speak', chat_message: chat_message, room_id: room_id

    $('#new_chat_message').submit (e) ->
      $this = $(this)
      textarea = $this.find('#chat_message_content')
      if $.trim(textarea.val()).length >= 1
        App.chat_message.speak textarea.val(), chat_messages.data('room-id')
        textarea.val('')
        e.preventDefault()
        return false
