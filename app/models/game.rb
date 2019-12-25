class Game < ApplicationRecord
  validate :title, presence: true, uniqueness: true

  has_many :gameusers
  has_many :users, through: :gameusers

  has_many :texts
end