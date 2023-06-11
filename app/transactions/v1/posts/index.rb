# frozen_string_literal: true

module V1
  module Posts
    class Index < BaseTransaction
      map  :unwrap
      step :index
      map  :render

      def index
        Success(Post.all.to_a)
      end

      def render(input)
        IndexPrint.render(input, root: :posts)
      end
    end
  end
end
