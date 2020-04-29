# frozen_string_literal: true

class GraphsUser < ApplicationRecord
  include LiberalEnum

  belongs_to :user
  belongs_to :graph

  enum role: { owner: 0, admin: 1, editor: 2, viewer: 3 }
  liberal_enum :role

  validates :graph_id, uniqueness: { scope: :user_id }
end
