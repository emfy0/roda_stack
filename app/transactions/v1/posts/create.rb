# frozen_string_literal: true

module V1
  module Posts
    class Create < BaseTransaction
      REQUEST_SCHEMA = Datacaster.schema do
        hash_schema(
          title: non_empty_string,
          description: non_empty_string,
          session: pass
        )
      end

      map  :unwrap
      step :typecast
      step :find_user, with: 'users.verify_session'
      step :create_post
      map  :render

      def create_post(input)
        Success(
          Post.create(
            title: input[:title],
            description: input[:description],
            user: input[:user]
          )
        )
      end

      def render(input)
        IndexPrint.render(input, root: :post)
      end
    end
  end
end
