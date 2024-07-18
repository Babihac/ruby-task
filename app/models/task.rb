# frozen_string_literal: true

class Task < ApplicationRecord
  has_one_attached :attachment

  belongs_to :project, optional: true
  belongs_to :user
  has_many :taggings, dependent: :destroy
  has_many :tags, through: :taggings

  validates :title, presence: true
  validate :attachment_size

  def status
    is_done ? I18n.t('tasks.status.done') : I18n.t('tasks.status.pending')
  end

  private

  def attachment_size
    return unless attachment.attached? && attachment.blob.byte_size > 10.megabytes

    errors.add(:attachment, 'is too big')
  end
end
