# frozen_string_literal: true

class GraphsUser < ApplicationRecord
  include LiberalEnum

  belongs_to :user
  belongs_to :graph

  enum role: { owner: 0, admin: 1, editor: 2, viewer: 3 }
  liberal_enum :role

  validates :graph_id, uniqueness: { scope: :user_id }
  validate :role_valid?, on: :sharing

  def role_valid?
    roles = self.class.roles.keys - ['owner']
    return if roles.include? role
    api_error(:invalid,
      opts: { role: role, roles: roles.join(', ') },
      role: role,
      avilable_roles: roles,
      column: :role)
    throw :abort
  end
end
