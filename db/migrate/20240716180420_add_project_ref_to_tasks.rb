# frozen_string_literal: true

class AddProjectRefToTasks < ActiveRecord::Migration[7.1]
  def change
    add_reference :tasks, :project, foreign_key: true
  end
end
