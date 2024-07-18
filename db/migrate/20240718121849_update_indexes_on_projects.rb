class UpdateIndexesOnProjects < ActiveRecord::Migration[7.1]
  def change
    # Assuming you already have an index on :title and :position, but they are not unique
    # First, remove them if they exist and are not unique
    remove_index :projects, :title if index_exists?(:projects, :title)
    remove_index :projects, :position if index_exists?(:projects, :position)

    # Add a unique index on :title and :user_id
    add_index :projects, %i[title user_id], unique: true

    # Add a unique index on :user_id and :position if you want position to be unique per user
    add_index :projects, %i[user_id position], unique: true
  end
end
