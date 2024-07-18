# frozen_string_literal: true

class AddOnDeleteCascadeToTaggings < ActiveRecord::Migration[7.1]
  def change
    remove_foreign_key :taggings, :tasks
    remove_foreign_key :taggings, :tags

    add_foreign_key :taggings, :tasks, on_delete: :cascade
    add_foreign_key :taggings, :tags, on_delete: :cascade
  end
end
