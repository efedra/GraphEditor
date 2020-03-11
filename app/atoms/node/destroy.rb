# frozen_string_literal: true

class Node::Destroy < Node::Base
  private

  def perform
    node.destroy
  end
end
