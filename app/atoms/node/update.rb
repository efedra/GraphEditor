# frozen_string_literal: true

class Node::Update < Node::Base
  private

  def perform
    @result = node
    @result.assign_attributes(node_params)
    @success = @result.save
    @error = @result.errors if fail?
  end
end
