class AddRewardToGuestReferrals < ActiveRecord::Migration[7.0]
  def change
    add_column :guest_referrals, :reward, :integer, default: 0
    add_column :guest_referrals, :reward_type, :string, default: "reward/ticket"
    add_column :guest_referrals, :reward_input, :integer, default: 0
  end
end
