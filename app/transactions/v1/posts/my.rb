# frozen_string_literal: true

module V1
  module Posts
    class My < BaseTransaction
      map  :unwrap
      step :find_user, with: 'users.verify_session'
      step :my
      map  :render

      def my(session)
        Success(
          Post.where(user: session[:user]).to_a
        )
      end

      def render(input)
        IndexPrint.render(input, root: :posts)
      end
    end
  end
end
