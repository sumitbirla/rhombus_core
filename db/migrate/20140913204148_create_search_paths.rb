class CreateSearchPaths < ActiveRecord::Migration
  def change
    create_table :core_search_paths do |t|
      t.string :short_code, null: false
      t.string :url, null: false
      t.string :description, null: false

      t.timestamps
    end
  end
end
