module Lita
  module Adapters
    class Mattermost < Adapter
      # insert adapter code here

      def run

      end

      def send_messages(target, messages)

      end

      def shut_down

      end

      def join(room_id)

      end

      def part(room_id)

      end

      Lita.register_adapter(:mattermost, self)
    end
  end
end
