class Ticket < ApplicationRecord
  ## Relationships
  belongs_to :instance
  belongs_to :itinerary
  belongs_to :seat

  belongs_to :user


  ## Validations
  validates :first_name, presence: true
  validates :last_name,  presence: true
  validates :age,        numericality: { only_integer: true, greater_than: 0 }
  validates :gender,     presence: true
  validates :seat,       presence: true
  validates :instance,   presence: true
end
