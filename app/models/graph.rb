# frozen_string_literal: true

class Graph < ApplicationRecord
  has_many :nodes, dependent: :nullify
end
