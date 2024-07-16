# frozen_string_literal: true

class Task < ApplicationRecord
  has_one_attached :attachment

  belongs_to :project, optional: true
  has_many :taggings, dependent: :destroy
  has_many :tags, through: :taggings

  validates :title, presence: true
  validate :attachment_size

  private

  def attachment_size
    return unless attachment.attached? && attachment.blob.byte_size > 10.megabytes

    errors.add(:attachment, 'is too big')
  end
end
