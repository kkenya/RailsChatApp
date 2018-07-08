App.chat_message = App.cable.subscriptions.create "ChatMessageChannel",
  connected: ->
    # Called when the subscription is ready for use on the server

  disconnected: ->
    # Called when the subscription has been terminated by the server

  received: (data) ->
    $('#chat_messages').append '<div>' + data['message'] + '</div'

  speak: (message) ->
    @perform 'speak', message: message

  $(document).on 'keypress', '[data-behavior~=speak_chat_messages]', (event) ->
    if event.keyCode is 13 #  press Enter key
      App.chat_message.speak event.target.value
      event.target.value = ''
      event.preventDefault()
