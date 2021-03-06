# frozen_string_literal: true
class NeoNode
  include ActiveGraph::Node

  property :title, type: String
  property :text, type: String, default: 'text'

  property :x, default: 0
  property :y, default: 0

  property :stroke, default: "black"
  property :strokeWidth, default: 1.5
  property :fill, default: "lightgreen"

  property :graph_id

  has_many :out, :neonodes, rel_class: :NeoEdge
  enum kind: %i[start finish inbetween]

  def view_model
    { id: uuid,
      symbolType: map_type(kind),
      x: x,
      y: y,
      label: title,
      text: text,
      strokeColor: stroke,
      strokeWidth: strokeWidth,
      color: fill }
  end

  def map_type(kind)
    case kind
    when :start
      'diamond'
    when :inbetween
      'circle'
    when :finish
      'star'
    end
  end
end