# frozen_string_literal: true

class Tag < ApplicationRecord
  has_many :taggings, dependent: :destroy
  has_many :tasks, through: :taggings

  belongs_to :user

  scope :by_user, ->(user_id) { where(user_id:).order(title: :asc) }
  scope :filter_by_title, lambda { |title|
    if title.present?
      where('title ILIKE ?', "%#{title}%")
    else
      all
    end
  }

  validates :title, presence: true, uniqueness: { scope: :user_id }
end
