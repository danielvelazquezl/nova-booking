class Offer < ApplicationRecord
  belongs_to :estate
  has_many :offer_details, dependent: :destroy
  accepts_nested_attributes_for :offer_details, allow_destroy: true,
                                reject_if: :all_blank
  delegate :name, :to => :estate, :prefix => true
  delegate :images, :to => :estate, :prefix => true
  self.per_page = 5

  scope :offers_by_owner, -> (current_owner_id) {
    joins(:estate).where('estates.owner_id = ?',current_owner_id)
  }
end
