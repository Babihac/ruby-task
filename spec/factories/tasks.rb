# frozen_string_literal: true

FactoryBot.define do
  factory :task do
    title { 'Test task' }
    description { 'Simple task for testing' }
    user
  end
end
