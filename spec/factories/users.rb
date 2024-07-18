# frozen_string_literal: true

require 'faker'

FactoryBot.define do
  factory :user do
    first_name { 'John' }
    last_name { 'Tester' }
    email { Faker::Internet.email }
    password { "#{Devise.friendly_token(8)}aA1!" }
  end
end
