# frozen_string_literal: true

class Node::Update < Node::Base
  private

  def atom_perform
    @result = node
    @result.update!(node_params)
    @status = :success
  end
end
