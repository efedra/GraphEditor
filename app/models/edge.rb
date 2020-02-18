# frozen_string_literal: true

class Edge < ApplicationRecord
  belongs_to :start, class_name: 'Node'
  belongs_to :finish, class_name: 'Node'
end
