# frozen_string_literal: true

class ProjectService
  class << self
    def shift_projects(position, user_id)
      user_projects = Project.by_user(user_id)
      return if position == user_projects.count + 1 || user_projects.count.zero?

      Project.transaction do
        projects_to_shift = user_projects.where(position: position..).order(position: :asc)
        projects_to_shift.reverse_each do |project|
          project.update(position: project.position + 1)
        end
      end
    rescue ActiveRecord::RecordInvalid
      Rails.logger.error("Failed to shift projects: #{e.message}")
    end

    def unshift_projects(deleted_position, user_id)
      user_projects = Project.by_user(user_id)
      return if deleted_position == user_projects.count + 1 || user_projects.count.zero?

      Project.transaction do
        projects_to_unshift = user_projects.where(position: deleted_position..).order(position: :asc)
        projects_to_unshift.each do |project|
          project.update(position: project.position - 1)
        end
      end
    rescue ActiveRecord::RecordInvalid
      Rails.logger.error("Failed to unshift projects: #{e.message}")
    end
  end
end
