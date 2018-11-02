class Airline < ApplicationRecord
  ## Relationships
  has_many :planes
  has_many :flights

  belongs_to :user


  ## Validations
  validates :name, presence: true
end
