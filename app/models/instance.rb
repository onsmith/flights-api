class Instance < ApplicationRecord
  ## Relationships
  belongs_to :flight
  has_many   :tickets

  belongs_to :user


  ## Validations
  validates :flight, presence: true
end
