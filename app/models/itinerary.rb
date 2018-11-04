class Itinerary < ApplicationRecord
  ## Relationships
  has_many :tickets

  belongs_to :user, optional: true
end
