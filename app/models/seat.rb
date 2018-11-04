class Seat < ApplicationRecord
  ## Relationships
  belongs_to :plane
  has_many   :tickets

  belongs_to :user, optional: true


  ## Validations
  validates :row,    presence: true
  validates :number, presence: true
  validates :plane,  presence: true

  validate :plane_must_be_accessible

  def plane_must_be_accessible
    if plane.user.present? && plane.user != user
      errors.add(:plane_id, "does not exist")
    end
  end
end
