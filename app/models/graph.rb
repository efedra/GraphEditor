# frozen_string_literal: true

class Graph < ApplicationRecord
  has_many :nodes, dependent: :nullify
  belongs_to :user, dependent: :destroy

  validates :state, presence: true

  def edges
    Edge.where(start_id: nodes.select(:id))
      .or(Edge.where(finish_id: nodes.select(:id)))
  end
end
