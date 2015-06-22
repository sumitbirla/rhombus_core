class AddDatafieldsToCoreDomains < ActiveRecord::Migration
  def change
    add_column :core_domains, :data1, :string
    add_column :core_domains, :data2, :string
  end
end
