# frozen_string_literal: true

FactoryBot.define do
  factory :project do
    title { 'test project' }
    position { 1 }
    user
  end
end
