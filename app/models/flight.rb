class Flight < ApplicationRecord
    ## Relationships
    belongs_to :airline
    belongs_to :plane

    belongs_to :arrival,   class_name: :Airport
    belongs_to :departure, class_name: :Airport

    belongs_to :next_flight, class_name: :Flight, inverse_of: last_flight
    has_one    :last_flight, class_name: :Flight, inverse_of: next_flight

    belongs_to :user

    has_many :instances


    ## Validations
    validates :departure,  presence: true
    validates :arrival,    presence: true
    validates :departs_at, presence: true
    validates :arrives_at, presence: true
    validates :number,     presence: true
  end
  