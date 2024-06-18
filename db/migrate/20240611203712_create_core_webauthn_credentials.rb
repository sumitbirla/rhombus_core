class CreateCoreWebauthnCredentials < ActiveRecord::Migration[7.1]
  def change
    create_table :core_webauthn_credentials do |t|
      t.string :credential_id, null: false
      t.boolean :user_present, null: false, default: false
      t.boolean :user_verified, null: false, default: false
      t.boolean :extension_data_included, null: false, default: false
      t.string :aaguid
      t.integer :user_id, null: false
      t.string :rp_id, null: false
      t.binary :public_key_cbor, null: false
      t.binary :extension_data_cbor
      t.string :nickname
      t.integer :sign_count, null: false, default: 0
      t.datetime :last_used

      t.timestamps
    end
  end
end
