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
      end

      def run
        saved_robot = robot
        @ws_client.on :open do
          p 'connected'
          saved_robot.trigger(:connected)
        end

        @ws_client.on :message do |message|
          # Receive message events
          if message['event'] == 'posted'
            data = message['data']
            p 'received:'
            p data
            post = JSON.parse(data['post'])
            user = Lita::User.find_by_name(data['sender_name'])
            user = Lita::User.create(user) unless user
            # room = Lita::Room.new(id: post['channel_id'], metadata: { name: data['channel_name'] })
            private_message = data['channel_type'] == 'D'
            source = Lita::Source.new(user: user, room: post['channel_id'], private_message: private_message)
            message = Lita::Message.new(saved_robot, post['message'], source)
            if private_message
              message.command!
            end
            saved_robot.receive(message)
          end
        end

        sleep
      end

      def send_messages(target, messages)
        messages.each do |message|
          p 'target'
          p target
          p 'message'
          p message
        end
      end

      def shut_down
        p 'shutting down'
        @ws_client.close
      end

      def join(room_id)

      end

      def part(room_id)

      end

      Lita.register_adapter(:mattermost, self)
    end
  end
end
