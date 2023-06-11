# frozen_string_literal: true

require 'app_helper'

describe 'Users', type: :doc, swagger_doc: 'v1/swagger.yaml' do
  rswag_generate_response!

  path '/api/v1/users/register' do
    post 'Register user' do
      description 'Creates new user and sets session cookie'

      parameter name: :username, in: :query, required: true, type: :string, description: 'Username'
      parameter name: :password, in: :query, required: true, type: :string, description: 'Password'

      response '200', 'Successful response' do
        set_default_schema!
        let(:username) { 'Nagibator337' }
        let(:password) { 'secure_password' }

        let(:expected_response) do
          { user: { username: } }
        end

        it 'returns a valid 200 response' do |example|
          expect_to_match_expected_response(example)
        end

        # extra example for code
        # it 'returns a valid 201 response' do |example|
        #   expect_to_match_expected_response(example)
        # end
      end

      response '422', 'Validation error' do
        set_default_schema!
        let(:username) { '' }
        let(:password) { '' }

        let(:expected_response) do
          {
            status: 'validation_error',
            validation_errors: {
              password: ['must be present'],
              username: ['must be present']
            }
          }
        end

        it 'returns 422 response' do |example|
          expect_to_match_expected_response(example)
        end
      end
    end
  end

  path '/api/v1/users/login' do
    post 'Login user' do
      description 'Login user and sets session cookie'

      response '200', 'Successful response' do
        set_default_schema!

        before do
          allow(User).to(receive(:[]).with(any_args).and_return(user))
        end

        let(:user) { create(:user, username:, password_hash: BCrypt::Password.create(password)) }

        parameter name: :username, in: :query, required: true, type: :string, description: 'Username'
        parameter name: :password, in: :query, required: true, type: :string, description: 'Password'

        let(:username) { 'Nagibator337' }
        let(:password) { 'secure_password' }

        let(:expected_response) do
          { user: { username: } }
        end

        it 'returns a valid 200 response' do |example|
          expect_to_match_expected_response(example)
        end
      end

      response '422', 'Validation error' do
        set_default_schema!
        let(:username) { '' }
        let(:password) { '' }

        let(:expected_response) do
          {
            status: 'validation_error',
            validation_errors: {
              password: ['must be present'],
              username: ['must be present']
            }
          }
        end

        it 'returns 422 response' do |example|
          expect_to_match_expected_response(example)
        end
      end

      response '400', 'Incorrect credentials provided' do
        set_default_schema!

        let(:username) { 'not_exists' }
        let(:password) { 'or_incorect' }

        let(:expected_response) do
          {
            status: 'error',
            error_message: 'invalid_username_or_password'
          }
        end

        it 'returns 400 response' do |example|
          expect_to_match_expected_response(example)
        end
      end
    end
  end

  path '/api/v1/users/me' do
    get 'Get me' do
      description 'Get user'

      response '200', 'Successful response' do
        set_default_schema!

        before do
          allow(User).to(receive(:[]).with(any_args).and_return(user))
        end

        let(:user) { build(:user) }

        let(:expected_response) do
          { user: { username: user.username } }
        end

        it 'returns a valid 200 response' do |example|
          expect_to_match_expected_response(example)
        end
      end

      response '403', 'Incorrect credentials provided' do
        set_default_schema!

        let(:expected_response) do
          {
            status: 'unauthorized'
          }
        end

        it 'returns 404 response' do |example|
          expect_to_match_expected_response(example)
        end
      end
    end
  end
end
