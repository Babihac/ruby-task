# frozen_string_literal: true

class Project < ApplicationRecord
  has_many :tasks, dependent: :destroy
  belongs_to :user

  validates :title, presence: true, uniqueness: { scope: :user_id }
  validates :position, presence: true
end
