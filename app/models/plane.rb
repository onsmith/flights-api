class Plane < ApplicationRecord
  ## Relationships
  belongs_to :airline, optional: true
  has_many   :flights
  has_many   :seats

  belongs_to :user, optional: true
end
