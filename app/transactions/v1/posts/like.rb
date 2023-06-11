# frozen_string_literal: true

module V1
  module Posts
    class Like < BaseTransaction
      REQUEST_SCHEMA = Datacaster.schema do
        hash_schema(
          id: integer
        )
      end

      map  :unwrap
      step :typecast
      step :like_post
      map  :render

      def like_post(input)
        id = input[:id]
        count = Post.where(id:).update(likes: Sequel[:likes] + 1)
        return Failure(:not_found) if count.zero?

        Success(Post[id])
      end

      def render(input)
        IndexPrint.render(input, root: :post)
      end
    end
  end
end
