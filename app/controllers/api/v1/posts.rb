# frozen_string_literal: true

class App
  hash_branch('api/v1', 'posts') do |r|
    r.is do
      r.get { render_response(V1::Posts::Index, params) }
      r.post { render_response(V1::Posts::Create, params.merge!(session: r.session)) }
    end

    r.get('my') do
      render_response(V1::Posts::My, params.merge!(session: r.session))
    end

    r.on Integer do |id|
      params.merge!(id:)

      r.put 'like' do
        render_response(V1::Posts::Like, params)
      end

      r.put 'dislike' do
        render_response(V1::Posts::Dislike, params)
      end
    end
  end
end
