# frozen_string_literal: true

class Tag < ApplicationRecord
  has_many :taggings, dependent: :destroy
  has_many :tasks, through: :taggings

  belongs_to :user

  validates :title, presence: true, uniqueness: { scope: :user_id }
end
