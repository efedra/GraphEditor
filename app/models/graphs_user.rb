# frozen_string_literal: true

class GraphsUser < ApplicationRecord
  include LiberalEnum

  belongs_to :user
  belongs_to :graph

  enum role: { owner: 0, admin: 1, editor: 2, viewer: 3 }
  liberal_enum :role

  validates :graph_id, uniqueness: { scope: :user_id }
  validate :role_valid?, on: :sharing

  after_create_commit { GraphBroadcastJob.perform_later graph, 'member_create', as_json }
  after_update_commit do
    GraphBroadcastJob.perform_later(graph, 'member_update', as_json) if saved_changes?
  end
  after_destroy { GraphBroadcastJob.perform_later graph, 'member_destroy', as_json }

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
