class User < ApplicationRecord
  validates :login, presence: true, uniqueness: true
  validates :password, presence: true, uniqueness: true
  validates :name, presence: true

  has_many :gameusers
  has_many :games, through:  :gameusers
end
