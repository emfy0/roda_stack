# frozen_string_literal: true

module V1
  module Users
    class Register < BaseTransaction
      REQUEST_SCHEMA = Datacaster.schema do
        hash_schema(
          username: non_empty_string,
          password: non_empty_string,
          session: pass
        )
      end

      map  :unwrap
      step :typecast
      step :create
      map  :render

      def create(input)
        u = User.new(
          username: input[:username],
          password_hash: BCrypt::Password.create(input[:password])
        )

        if u.valid?
          u.save_changes
          input[:session][:user_id] = u.id
          Success(u)
        else
          Failure(validation_errors: u.errors.to_h)
        end
      end

      def render(input)
        RegisterPrint.render(input, root: :user)
      end
    end
  end
end
