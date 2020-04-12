# frozen_string_literal: true

class GraphsUser < ApplicationRecord
  include LiberalEnum

  belongs_to :user
  belongs_to :graph

  enum scope: { owner: 0, admin: 1, editor: 2, viewer: 3 }
  liberal_enum :scope
end
