class AddOrderAmountToSaleTickets < ActiveRecord::Migration[7.0]
  def change
    add_column :sale_tickets, :order_amount, :integer
  end
end
