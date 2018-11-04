class Plane < ApplicationRecord
  ## Relationships
  belongs_to :airline, optional: true
  has_many   :flights
  has_many   :seats

  belongs_to :user, optional: true


  ## Validations
  validate :airline_must_be_accessible

  def airline_must_be_accessible
    if airline.present? && airline.user.present? && airline.user != user
      errors.add(:airline_id, "does not exist")
    end
  end
end
