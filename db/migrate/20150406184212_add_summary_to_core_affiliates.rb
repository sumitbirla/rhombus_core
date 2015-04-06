class AddSummaryToCoreAffiliates < ActiveRecord::Migration
  def change
    add_column :core_affiliates, :summary, :string
  end
end
