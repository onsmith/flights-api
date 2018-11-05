class User < ActiveRecord::Base
  ## Relationships
  has_many :airlines
  has_many :flights
  has_many :airports
  has_many :planes
  has_many :instances
  has_many :seats
  has_many :tickets
  has_many :itineraries



  # Include default devise modules. Others available are:
  #   :recoverable, :confirmable, :lockable, :timeoutable,
  #   :trackable, :omniauthable
  devise :database_authenticatable, :registerable, :rememberable, :validatable


  # Define these methods to make devise happy
  def remember_me
    true
  end
  def email
    username
  end
  def email_required?
    false
  end
  def email_changed?
    false
  end
  def will_save_change_to_email?
    false
  end
end
