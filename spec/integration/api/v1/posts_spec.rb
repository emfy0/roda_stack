# frozen_string_literal: true

require 'app_helper'

describe 'Posts', type: :doc, swagger_doc: 'v1/swagger.yaml' do
  rswag_generate_response!

  path '/api/v1/posts' do
    get 'Get all posts' do
      description 'Get all posts'

      response '200', 'Successful response' do
        set_default_schema!

        let!(:posts) do
          create_list(:post, 3)
        end

        let(:expected_response) do
          { posts: posts.map(&:to_hash).map { |post| post.tap { |p| p.delete(:user_id) } } }
        end

        it 'returns a valid 200 response' do |example|
          expect_to_match_expected_response(example)
        end
      end
    end

    post 'Create post' do
      description 'Create post'

      parameter name: :title, in: :query, required: true, type: :string
      parameter name: :description, in: :query, required: true, type: :string

      let(:title) { 'post title' }
      let(:description) { 'post description' }

      response '200', 'Successful response' do
        set_default_schema!

        let(:post) { Post.last.to_hash.tap { |p| p.delete(:user_id) } }

        stub_container('users.verify_session', ->(input) { Success(input) })

        let(:expected_response) do
          { post: }
        end

        it 'returns a valid 200 response' do |example|
          expect_to_match_expected_response(example)
        end
      end

      response '403', 'Unauthorized' do
        set_default_schema!

        let(:expected_response) do
          { status: 'unauthorized' }
        end

        it 'returns 403 response' do |example|
          expect_to_match_expected_response(example)
        end
      end
    end
  end

  path '/api/v1/posts/my' do
    get 'Get my posts' do
      description 'Get my posts'

      response '200', 'Successful response' do
        set_default_schema!

        let(:user) { create(:user) }

        let!(:posts) do
          create_list(:post, 3, user:)
        end

        let(:expected_response) do
          { posts: posts.map(&:to_hash).map { |post| post.tap { |p| p.delete(:user_id) } } }
        end

        it 'returns a valid 200 response' do |example|
          Application::CONTAINER.stub('users.verify_session', ->(input) { Success(input.merge(user:)) })
          expect_to_match_expected_response(example)
          Application::CONTAINER.unstub('users.verify_session')
        end
      end

      response '403', 'Unauthorized' do
        set_default_schema!

        let(:expected_response) do
          { status: 'unauthorized' }
        end

        it 'returns 403 response' do |example|
          expect_to_match_expected_response(example)
        end
      end
    end
  end

  path '/api/v1/posts/{id}/like' do
    put 'Like post' do
      description 'Like post'

      response '200', 'Successful response' do
        set_default_schema!

        parameter name: :id, in: :path, required: true, type: :string

        let(:id) { post.id.to_s }

        let(:post) do
          create(:post)
        end

        let(:expected_response) do
          { post: post.reload.to_hash.tap { |p| p.delete(:user_id) } }
        end

        it 'returns a valid 200 response' do |example|
          expect_to_match_expected_response(example)
        end
      end
    end
  end

  path '/api/v1/posts/{id}/dislike' do
    put 'Disike post' do
      description 'Dislike post'

      response '200', 'Successful response' do
        set_default_schema!

        parameter name: :id, in: :path, required: true, type: :string

        let(:id) { post.id.to_s }

        let(:post) do
          create(:post)
        end

        let(:expected_response) do
          { post: post.reload.to_hash.tap { |p| p.delete(:user_id) } }
        end

        it 'returns a valid 200 response' do |example|
          expect_to_match_expected_response(example)
        end
      end
    end
  end
end
