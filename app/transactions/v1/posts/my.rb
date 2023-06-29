# frozen_string_literal: true

module V1
  module Posts
    class My < BaseTransaction
      MAX_PER_PAGE = 25

      REQUEST_SCHEMA = Datacaster.schema do
        hash_schema(
          offset: optional(to_integer & check(&:positive?)),
          limit: optional(to_integer & check(&:positive?)),
          session: pass
        )
      end

      map  :unwrap
      step :typecast
      step :find_user, with: 'users.verify_session'
      step :my
      map  :render

      def my(input)
        posts = Post.where(user: input[:user])

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
