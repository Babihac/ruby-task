# frozen_string_literal: true

FactoryBot.define do
  factory :user do
    first_name { 'John' }
    last_name { 'Tester' }
    password { "#{Devise.friendly_token(8)}aA1!" }
  end
end
