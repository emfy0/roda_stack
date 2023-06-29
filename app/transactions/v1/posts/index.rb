# frozen_string_literal: true

module V1
  module Posts
    class Index < BaseTransaction
      MAX_PER_PAGE = 25

      REQUEST_SCHEMA = Datacaster.schema do
        hash_schema(
          offset: optional(to_integer & check(&:positive?)),
          limit: optional(to_integer & check(&:positive?))
        )
      end

      map  :unwrap
      step :typecast
      step :index
      map  :render

      def index(input)
        posts = Post

        limit =
          if input[:limit]
            [input[:limit], MAX_PER_PAGE].min
          else
            MAX_PER_PAGE
          end

        offset = input[:offset].to_i

        total = posts.count

        posts = posts.limit(limit)
        posts = posts.offset(offset)

        Success(posts: posts.to_a, meta: { total:, limit:, offset: })
      end

      def render(input)
        IndexPrint.render(
          input[:posts], root: :posts, meta: input[:meta]
        )
      end
    end
  end
end
