# frozen_string_literal: true

class Tagging < ApplicationRecord
  belongs_to :task
  belongs_to :tag
end
