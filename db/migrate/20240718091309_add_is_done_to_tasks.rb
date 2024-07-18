# frozen_string_literal: true

class AddIsDoneToTasks < ActiveRecord::Migration[7.1]
  def change
    add_column :tasks, :is_done, :boolean, default: false, null: false
  end
end
