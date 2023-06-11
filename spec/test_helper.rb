# frozen_string_literal: true

def rswag_generate_response!
  after do |example|
    content = example.metadata[:response][:content] || {}
    example_spec = {
      'application/json' => {
        example: JSON.parse(@response.body, symbolize_names: true)
      }
    }

    example.metadata[:response][:content] = content.deep_merge(example_spec)
  end
end

def set_default_schema!
  schema({})
  # produces('application/json')
end

def parsed_response
  JSON.parse(@response.body, symbolize_names: true)
end

def expect_to_match_expected_response(example)
  @response = submit_request(example.metadata)
  expect(parsed_response).to eq(expected_response)
end

def stub_container(name, action)
  around do |t|
    Application::CONTAINER.stub(name, action)
    t.run
    Application::CONTAINER.unstub(name)
  end
end
