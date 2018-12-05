class Ticket < ApplicationRecord
  ## Relationships
  belongs_to :instance, optional: true
  belongs_to :itinerary, optional: true
  belongs_to :seat, optional: true

  belongs_to :user, optional: true


  ## Validations
  validates :first_name, presence: true
  validates :last_name,  presence: true
  validates :age,        numericality: { only_integer: true, greater_than: 0 }
  validates :gender,     presence: true

  validate :instance_must_be_accessible,
           :itinerary_must_be_accessible,
           :seat_must_be_accessible

  def instance_must_be_accessible
    if instance.present? && instance.user.present? && instance.user != user
      errors.add(:instance_id, "does not exist")
    end
  end

  def itinerary_must_be_accessible
    if itinerary.present? && itinerary.user.present? && itinerary.user != user
      errors.add(:itinerary_id, "does not exist")
    end
  end

  def seat_must_be_accessible
    if seat.present? && seat.user.present? && seat.user != user
      errors.add(:seat_id, "does not exist")
    end
  end
end
