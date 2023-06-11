# frozen_string_literal: true

module V1
  module Users
    class Login < BaseTransaction
      REQUEST_SCHEMA = Datacaster.schema do
        hash_schema(
          username: non_empty_string,
          password: non_empty_string,
          session: pass
        )
      end

      map  :unwrap
      step :typecast
      step :find_user
      map  :render

      def find_user(input)
        u = User.find(username: input[:username])

        return error_message unless u
        return error_message unless BCrypt::Password.new(u.password_hash) == input[:password]

        input[:session][:user_id] = u.id
        Success(u)
      end

      def render(input)
        RegisterPrint.render(input, root: :user)
      end

      private

      def error_message = Failure(error_message: :invalid_username_or_password)
    end
  end
end
