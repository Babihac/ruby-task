# frozen_string_literal: true

require 'faker'

ActiveRecord::Base.transaction do
  User.create!(
    email: 'tester1@test.cz',
    password: 'password123',
    password_confirmation: 'password123',
    first_name: 'John',
    last_name: 'Doe'
  )

  # User 2
  User.create!(
    email: 'tester2@test.cz',
    password: 'password123',
    password_confirmation: 'password123',
    first_name: 'Jane',
    last_name: 'Doe'
  )

  users = User.all

  users.each do |user|
    (1..20).each do |i|
      new_tag = user.tags.create(title: "#{Faker::Lorem.word} #{i}")
      puts "XOXOXO: #{new_tag.errors.full_messages}" unless new_tag.valid?

      user.projects.create!(title: "#{Faker::Lorem.word} #{i}", position: i)
    end
  end

  all_tags = Tag.all

  users.each do |user|
    20.times do
      random_project = user.projects.sample
      random_tags = all_tags.sample(rand(1..3))

      user.tasks.create!(
        title: Faker::Lorem.sentence(word_count: 3),
        project: random_project,
        description: Faker::Lorem.sentence(word_count: 10),
        tags: random_tags
      )
    end
  end
end
