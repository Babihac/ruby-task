# frozen_string_literal: true

class Project < ApplicationRecord
  has_many :tasks, dependent: :destroy

  validates :title, presence: true, uniqueness: true
  validates :position, presence: true, uniqueness: true
end
