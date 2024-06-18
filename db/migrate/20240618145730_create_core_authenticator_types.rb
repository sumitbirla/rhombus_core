class CreateCoreAuthenticatorTypes < ActiveRecord::Migration[7.1]
  def change
    create_table :core_authenticator_types do |t|
      t.string :aaguid, null: false
      t.string :name, null: false
      t.text :icon_dark
      t.text :icon_light
    end
  end
end
