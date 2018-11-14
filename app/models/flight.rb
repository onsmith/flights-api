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

  validate :plane_must_be_accessible,
           :departure_must_be_accessible,
           :arrival_must_be_accessible,
           :next_flight_must_be_accessible,
           :airline_must_be_accessible,
           :flight_segments_must_stop_at_same_airport

  def plane_must_be_accessible
    if plane.present? && plane.user.present? && plane.user != user
      errors.add(:plane_id, "does not exist")
    end
  end

  def departure_must_be_accessible
    if departure.present? && departure.user.present? && departure.user != user
      errors.add(:departure_id, "does not exist")
    end
  end

  def arrival_must_be_accessible
    if arrival.present? && arrival.user.present? && arrival.user != user
      errors.add(:arrival_id, "does not exist")
    end
  end

  def next_flight_must_be_accessible
    if next_flight.present? && next_flight.user.present? && next_flight.user != user
      errors.add(:next_flight_id, "does not exist")
    end
  end

  def airline_must_be_accessible
    if airline.present? && airline.user.present? && airline.user != user
      errors.add(:airline_id, "does not exist")
    end
  end

  def flight_segments_must_stop_at_same_airport
    if next_flight.present? && arrival != next_flight.departure
      errors.add(:next_flight_id, "cannot depart from a different airport")
    end
  end
end
