class Plane < ApplicationRecord
  ## Relationships
  belongs_to :airline
  has_many   :flights
  has_many   :seats

  belongs_to :user
end
