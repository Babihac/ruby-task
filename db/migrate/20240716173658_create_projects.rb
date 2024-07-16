# frozen_string_literal: true

class CreateProjects < ActiveRecord::Migration[7.1]
  def change
    create_table :projects do |t|
      t.string :title, null: false
      t.integer :position, null: false
      t.timestamps
    end

    add_index :projects, :title, unique: true
    add_index :projects, :position, unique: true
  end
end
