module Devise
  module Strategies
    class JsonWebToken < Base
      def valid?
        !request.headers['Authorization'].nil?
      end

      def authenticate!
        claims = get_claims

        user = User.find_by_id(claims[0].fetch('user_id')) if claims

        if user
          success! user
        else
          fail!
        end
      end

      private

      def get_claims
        auth_header = request.headers['Authorization'] and
          token = auth_header.split(' ').last and
          ::JsonWebToken.decode(token)
      rescue
        nil
      end
    end
  end
end
