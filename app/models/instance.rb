class Instance < ApplicationRecord
  ## Relationships
  belongs_to :flight
  has_many   :tickets

  belongs_to :user, optional: true


  ## Validations
  validates :is_cancelled, inclusion: { in: [ true, false ] }, on: :update

  validates :date, presence: true
  validates :flight, presence: true

  validate :flight_must_be_accessible

  def flight_must_be_accessible
    if flight.present? && flight.user.present? && flight.user != user
      errors.add(:flight_id, "does not exist")
    end
  end
end
