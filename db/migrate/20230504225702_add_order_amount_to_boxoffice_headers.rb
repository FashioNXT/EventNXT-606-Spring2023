class AddOrderAmountToBoxofficeHeaders < ActiveRecord::Migration[7.0]
  def change
    add_column :boxoffice_headers, :order_amount, :integer
  end
end
