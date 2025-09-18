class AddGuestFieldsToOrders < ActiveRecord::Migration[8.0]
  def change
    add_column :orders, :guest_name, :string
    add_column :orders, :guest_email, :string
    add_column :orders, :guest_phone, :string
  end
end
