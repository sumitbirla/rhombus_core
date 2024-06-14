class CreateCoreWebauthnCredentials < ActiveRecord::Migration[7.1]
  def change
    create_table :core_webauthn_credentials do |t|
      t.string :credential_id, null: false
      t.integer :user_id, null: false
      t.string :rp_id, null: false
      t.binary :public_key_cbor, null: false
      t.string :nickname
      t.integer :sign_count, null: false, default: 0
      t.datetime :last_used

      t.timestamps
    end
  end
end
