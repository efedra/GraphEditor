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

  has_many :edges, ->() { unscope(:where).where("start_id = :node_id OR finish_id = :node_id", node_id: id) }

end
