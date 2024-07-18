# frozen_string_literal: true

class ProjectService
  class << self
    def shift_projects(position)
      return if position == Project.count + 1 || Project.count.zero?

      Project.transaction do
        projects_to_shift = Project.where(position: position..).order(position: :asc)
        projects_to_shift.reverse_each do |project|
          project.update(position: project.position + 1)
        end
      end
    rescue ActiveRecord::RecordInvalid
      Rails.logger.error("Failed to shift projects: #{e.message}")
    end
  end
end