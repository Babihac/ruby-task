# frozen_string_literal: true

class Task < ApplicationRecord
  has_one_attached :attachment

  validates :attachment, size: { less_than: 10.megabytes }
end
