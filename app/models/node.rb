# frozen_string_literal: true

class Node < ApplicationRecord
  belongs_to :graph
  has_many :output_edges,
    foreign_key: :start_id,
    class_name: 'Edge',
    dependent: :nullify,
    inverse_of: :start
  has_many :input_edges,
    foreign_key: :finish_id,
    class_name: 'Edge',
    dependent: :nullify,
    inverse_of: :finish
  # TODO: i don't know how to build this relation.
  # i want (input_edges + output_edges) as one has_many...
  # has_many :edges, -> { includes(:output_edges) }, foreign_key: :start_id

  def edges
    Edge.where("start_id = :node_id OR finish_id = :node_id", node_id: id)
  end
end
