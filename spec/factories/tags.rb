# frozen_string_literal: true

FactoryBot.define do
  factory :tag do
    title { 'test tag' }
    user
  end
end
