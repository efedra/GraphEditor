# frozen_string_literal: true

class Node::Destroy < Node::Base
  private

  def atom_perform
    node.destroy
    @status = :successfully_destoyed
  end
end
