# frozen_string_literal: true

class Node::Create < Node::Base
  private

  def atom_perform
    @result = nodes.new(node_params)
    @result.save!
    @status = :successfully_created
  end
end
