class Seat < ApplicationRecord
  ## Relationships
  belongs_to :plane
  has_many   :tickets

  belongs_to :user, optional: true


  ## Validations
  validates :row,    presence: true
  validates :number, presence: true
  validates :plane,  presence: true

  validates :is_window, inclusion: { in: [ true, false ] }, on: :update
  validates :is_aisle,  inclusion: { in: [ true, false ] }, on: :update
  validates :is_exit,   inclusion: { in: [ true, false ] }, on: :update

  validate :plane_must_be_accessible

  def plane_must_be_accessible
    if plane.present? && plane.user.present? && plane.user != user
      errors.add(:plane_id, "does not exist")
    end
  end
end
