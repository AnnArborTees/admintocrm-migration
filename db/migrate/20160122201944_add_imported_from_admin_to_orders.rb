class AddImportedFromAdminToOrders < ActiveRecord::Migration
  def change
    add_column :orders, :imported_from_admin, :boolean, :default => false 
  end
end
