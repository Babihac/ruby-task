# frozen_string_literal: true

class CreateTaggings < ActiveRecord::Migration[7.1]
  def change
    # name taggings is use in gem for tags: https://rubygems.org/gems/acts-as-taggable-on
    create_table :taggings do |t|
      t.references :task, null: false, foreign_key: true
      t.references :tag, null: false, foreign_key: true

      t.timestamps
    end
  end
end
