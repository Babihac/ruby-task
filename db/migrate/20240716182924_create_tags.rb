# frozen_string_literal: true

class CreateTags < ActiveRecord::Migration[7.1]
  def change
    create_table :tags do |t|
      t.timestamps
      t.string :title, null: false
    end

    add_index :tags, :title, unique: true
  end
end
