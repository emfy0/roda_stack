# frozen_string_literal: true

class App
  hash_branch('api/v1', 'users') do |r|
    r.on 'register' do
      r.post do
        render_response(V1::Users::Register, params.merge!(session: r.session))
      end
    end

    r.on 'login' do
      r.post do
        render_response(V1::Users::Login, params.merge!(session: r.session))
      end
    end

    r.on 'me' do
      r.get do
        render_response(V1::Users::Me, params.merge!(session: r.session))
      end
    end
  end
end
