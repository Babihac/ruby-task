# frozen_string_literal: true

class Task < ApplicationRecord
  FILTERABLE_PARAMS = %i[title status project_id].freeze

  has_one_attached :attachment

  belongs_to :project, optional: true
  belongs_to :user

  has_many :taggings, dependent: :destroy
  has_many :tags, through: :taggings

  scope :by_user, ->(user_id) { includes(%i[tags project]).where(user_id:).order(created_at: :desc) }
  scope :detail, ->(id) { includes(%i[tags]).with_attached_attachment.find(id) }
  scope :filter_by_project_id, ->(project_id) { where(project_id:).order(created_at: :desc) }
  scope :filter_by_title, ->(title) { where('title ILIKE ?', "%#{title}%") }
  scope :filter_by_status, ->(status) { where(is_done: status) }

  def status
    is_done ? I18n.t('tasks.status.done') : I18n.t('tasks.status.pending')
  end

  validates :title, presence: true
  validate :attachment_size

  # this should be concern in real life
  class << self
    def filter(params)
      params.compact.reduce(all) do |tasks, (key, value)|
        next tasks if FILTERABLE_PARAMS.exclude?(key.to_sym)

        tasks.public_send("filter_by_#{key}", value)
      end
    end
  end

  private

  def attachment_size
    return unless attachment.attached? && attachment.blob.byte_size > 10.megabytes

    errors.add(:attachment, 'is too big')
  end
end
