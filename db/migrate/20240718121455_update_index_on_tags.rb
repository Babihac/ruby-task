# frozen_string_literal: true

class UpdateIndexOnTags < ActiveRecord::Migration[7.1]
  def change
    remove_index :tags, :title if index_exists?(:tags, :title)
    add_index :tags, %i[title user_id], unique: true
  end
end
