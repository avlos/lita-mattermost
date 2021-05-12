require('mattermost')

module Lita
  module Adapters
    class Mattermost < Adapter
      config :server, type: String, required: true
      config :token, type: String, required: true

      def initialize(robot)
        super
        @client = ::Mattermost.new_client(config.server)
        @client.use_access_token(config.token)

        @ws_client = ::Mattermost::WebSocketClient.new("#{config.server}/api/v4/websocket", config.token)

        me = @client.get_me().body
        @me = Lita::User.create(me['id'], { name: me['username'] })
      end

      def run
        # Make variables available in event handlers
        saved_robot = robot
        me = @me

        @ws_client.on :open do
          saved_robot.trigger(:connected)
        end

        @ws_client.on :message do |message|
          # Receive message events
          if message['event'] == 'posted'
            data = message['data']
            post = JSON.parse(data['post'])

            user = Lita::User.create(post['user_id'], { name: data['sender_name'] })

            # Ignore own messages
            if user.id != me.id
              private_message = data['channel_type'] == 'D'
              source = Lita::Source.new(user: user, room: post['channel_id'], private_message: private_message)
              message = Lita::Message.new(saved_robot, post['message'], source)
              if private_message
                message.command!
              end
              saved_robot.receive(message)
            end
          end
        end

        sleep
      end

      def send_messages(target, messages)
        channel = target.room
        if channel.nil?
          user = target.user.id
          channel = @client.create_direct_channel(@me.id, user).body['id']
        end

        messages.each do |message|
          @client.create_post({ channel_id: channel, message: message })
        end
      end

      def shut_down
        @ws_client.close
      end

      def join(room_id)
        @client.add_user_to_channel(room_id, @me.id)
      end

      def part(room_id)
        @client.remove_user_from_channel(room_id, @me.id)
      end

      Lita.register_adapter(:mattermost, self)
    end
  end
end
