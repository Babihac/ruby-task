# frozen_string_literal: true

class CreateTasks < ActiveRecord::Migration[7.1]
  def change
    create_table :tasks do |t|
      t.timestamps
      t.string :title, null: false
      t.text :description
    end
  end
end
