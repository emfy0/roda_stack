# frozen_string_literal: true

class App
  route do |r|
    r.on 'api/v1' do
      r.hash_branches('api/v1')
    end

    r.public if ENVIRONMENT != :production

    r.on 'api-docs' do
      r.run RodaRswag
    end
  end
end
