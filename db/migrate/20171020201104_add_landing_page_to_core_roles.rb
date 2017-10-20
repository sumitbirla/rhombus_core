class AddLandingPageToCoreRoles < ActiveRecord::Migration
  def change
    add_column :core_roles, :landing_page, :string
  end
end
