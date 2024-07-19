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
      user.tags.create!(title: "#{Faker::Hobby.activity} #{i}")

      user.projects.create!(title: "#{Faker::Quote.famous_last_words} #{i}", position: i)

      random_project = user.projects.sample
      random_tags = user.tags.sample(rand(1..3))

      user.tasks.create!(
        title: "#{i} - #{Faker::Music::Hiphop.artist}",
        project: random_project,
        description: "#{Faker::GreekPhilosophers.quote} #{i}",
        tags: random_tags
      )
    end
  end
end
