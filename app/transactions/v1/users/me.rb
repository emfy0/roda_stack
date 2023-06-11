# frozen_string_literal: true

module V1
  module Users
    class Me < BaseTransaction
      REQUEST_SCHEMA = Datacaster.schema do
        hash_schema(
          session: pass
        )
      end

      map  :unwrap
      step :typecast
      step :find_user, with: 'users.verify_session'
      map  :render

      def render(input)
        RegisterPrint.render(input[:user], root: :user)
      end
    end
  end
end
