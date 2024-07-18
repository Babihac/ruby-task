# frozen_string_literal: true

class Project < ApplicationRecord
  has_many :tasks, dependent: :destroy
  belongs_to :user

  scope :by_user, ->(user_id) { where(user_id:).order(position: :asc) }
  scope :filter_by_title, lambda { |title|
                            if title.present?
                              where('title ILIKE ?', "%#{title}%")
                            else
                              all
                            end
                          }

  validates :title, presence: true, uniqueness: { scope: :user_id }
  validates :position, presence: true
end
