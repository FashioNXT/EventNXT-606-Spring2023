class AddCostToGuestReferrals < ActiveRecord::Migration[7.0]
  def change
    add_column :guest_referrals, :cost, :integer, default:0
    add_column :guest_referrals, :status, :boolean, default:false    
  end
end
