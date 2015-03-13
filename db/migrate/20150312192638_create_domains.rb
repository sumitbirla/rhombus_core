class CreateDomains < ActiveRecord::Migration
  def change
    create_table :core_domains do |t|
      t.string :name, null: false
      t.string :url, null: false
      t.boolean :default, null: false, default: false

      t.timestamps null: false
    end
  end
end
