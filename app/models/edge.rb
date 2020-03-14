# frozen_string_literal: true

class Edge < ApplicationRecord
  belongs_to :start, class_name: 'Node'
  belongs_to :finish, class_name: 'Node'

  validates :start, :finish, presence: true

  def as_json(options)
    super({ only: %i[id start_id finish_id text weight] }.merge(options))
  end
end
