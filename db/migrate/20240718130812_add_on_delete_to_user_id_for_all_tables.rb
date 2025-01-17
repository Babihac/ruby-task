# frozen_string_literal: true

class AddOnDeleteToUserIdForAllTables < ActiveRecord::Migration[7.1]
  def change
    remove_foreign_key :projects, :users
    add_foreign_key :projects, :users, on_delete: :cascade

    remove_foreign_key :tags, :users
    add_foreign_key :tags, :users, on_delete: :cascade

    remove_foreign_key :tasks, :users
    add_foreign_key :tasks, :users, on_delete: :cascade

    remove_foreign_key :tasks, :projects
    add_foreign_key :tasks, :projects, on_delete: :cascade
  end
end
