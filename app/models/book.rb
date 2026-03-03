class Book < ApplicationRecord
  has_many :reservations, dependent: :destroy

  enum status: { available: 0, checked_out: 1, reserved: 2 }

  validates :title, presence: true
  validates :author, presence: true
end
