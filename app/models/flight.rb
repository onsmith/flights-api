class Flight < ApplicationRecord
  ## Relationships
  belongs_to :airline, optional: true
  belongs_to :plane, optional: true

  belongs_to :arrival,   class_name: :Airport
  belongs_to :departure, class_name: :Airport

  belongs_to :next_flight, class_name: :Flight, inverse_of: :last_flight, optional: true
  has_one    :last_flight, class_name: :Flight, inverse_of: :next_flight

  belongs_to :user, optional: true

  has_many :instances


  ## Validations
  validates :departure,  presence: true
  validates :arrival,    presence: true
  validates :departs_at, presence: true
  validates :arrives_at, presence: true
  validates :number,     presence: true

  validate :related_records_must_be_accessible,
           :flight_segments_must_stop_at_same_airport

  def related_records_must_be_accessible
    if plane.present? && plane.user.present? && plane.user != user
      errors.add(:plane_id, "is inaccessible or does not exist")
    end

    if departure.user.present? && departure.user != user
      errors.add(:departure_id, "is inaccessible or does not exist")
    end

    if arrival.user.present? && arrival.user != user
      errors.add(:arrival_id, "is inaccessible or does not exist")
    end

    if next_flight.present? && next_flight.user.present? && next_flight.user != user
      errors.add(:next_flight_id, "is inaccessible or does not exist")
    end

    if airline.present? && airline.user.present? && airline.user != user
      errors.add(:airline_id, "is inaccessible or does not exist")
    end
  end

  def flight_segments_must_stop_at_same_airport
    if next_flight.present? && arrival != next_flight.departure
      errors.add(:next_flight_id, "cannot depart from a different airport")
    end
  end
end
