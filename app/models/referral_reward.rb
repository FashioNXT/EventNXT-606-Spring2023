class ReferralReward < ApplicationRecord
    belongs_to :event

    has_many :guest_referral_rewards
    has_many :guests, through: :guest_referral_rewards

    validates :reward, presence: true
    validates :event_id, presence: true, uniqueness: true
    validates :min_count, presence: true, numericality: {greater_than_or_equal_to: 0}
end
