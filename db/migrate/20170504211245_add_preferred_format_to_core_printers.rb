class AddPreferredFormatToCorePrinters < ActiveRecord::Migration
  def change
    add_column :core_printers, :preferred_format, :string
  end
end
