class Room < ApplicationRecord
  belongs_to :estate

  has_many :facilities_rooms
  has_many :facilities, through: :facilities_rooms
  has_many_attached :images
  has_many :booking_detail

  extend Enumerize

  enumerize :room_type, in: [:single, :double, :family]
  enumerize :status, in: [:published, :not_published]

  def self.room_type_for(id)
    find(id).room_type.text
  end
  def self.room_capacity_for(id)
    find(id).capacity
  end

  scope :booking_details, -> { BookingDetail.joins(:room) }

end
