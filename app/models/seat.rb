class Seat < ApplicationRecord
  ## Relationships
  belongs_to :plane
  has_many   :tickets

  belongs_to :user


  ## Validations
  validates :row,    presence: true
  validates :number, presence: true
  validates :plane,  presence: true
end
