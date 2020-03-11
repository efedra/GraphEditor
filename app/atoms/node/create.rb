# frozen_string_literal: true

class Node::Create < Node::Base
  private

  def perform
    @result = nodes.new(node_params)

    @success = @result.save
    @error = @result.errors if fail?
  end
end
