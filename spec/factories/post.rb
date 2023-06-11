# frozen_string_literal: true

FactoryBot.define do
  factory :post do
    sequence(:title) { |i| "title#{i}" }
    sequence(:description) { |i| "description#{i}" }
  end
end
