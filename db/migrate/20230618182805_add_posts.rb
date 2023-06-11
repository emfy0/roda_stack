# frozen_string_literal: true

Sequel.migration do
  change do
    create_table(:posts) do
      primary_key :id
      foreign_key :user_id, :users
      String :title, null: false
      String :description, null: false
      Integer :likes, null: false, default: 0
      Integer :dislikes, null: false, default: 0
    end
  end
end
