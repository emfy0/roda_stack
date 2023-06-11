# frozen_string_literal: true

FactoryBot.define do
  factory :user do
    sequence(:username) { |i| "title#{i}" }
    password_hash { 'secure_hash' }
  end
end
