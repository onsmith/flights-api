class Airline < ApplicationRecord
  ## Relationships
  has_many :planes
  has_many :flights

  belongs_to :user, optional: true


  ## Validations
  validates :name, presence: true
end
