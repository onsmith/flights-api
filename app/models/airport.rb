class Airport < ApplicationRecord
  ## Relationships
  has_many :arrivals,   class_name: :Flight
  has_many :departures, class_name: :Flight

  belongs_to :user, optional: true


  ## Validations
  validates :name, presence: true
  validates :code, presence: true
end
