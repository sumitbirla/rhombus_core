class CreateTables < ActiveRecord::Migration
  def change
    
    create_table "core_affiliate_categories", force: true do |t|
      t.integer "affiliate_id", null: false
      t.integer "category_id",  null: false
    end

    add_index "core_affiliate_categories", ["affiliate_id"], name: "index_affiliate_categories_on_affiliate_id", using: :btree
    add_index "core_affiliate_categories", ["category_id"], name: "index_affiliate_categories_on_category_id", using: :btree
    
    create_table "core_affiliates", force: true do |t|
      t.string   "name",                           null: false
      t.string   "code"
      t.string   "slug",           default: "",    null: false
      t.boolean  "featured",       default: false, null: false
      t.boolean  "active",         default: false, null: false
      t.string   "contact_person"
      t.string   "street1"
      t.string   "street2"
      t.string   "city"
      t.string   "state"
      t.string   "zip"
      t.string   "country"
      t.string   "phone"
      t.string   "fax"
      t.string   "email"
      t.string   "website"
      t.string   "logo"
      t.text     "description"
      t.datetime "created_at"
      t.datetime "updated_at"
    end
    
    create_table "core_authorizations", force: true do |t|
      t.integer  "user_id"
      t.string   "provider"
      t.string   "uid"
      t.string   "name"
      t.text     "token"
      t.string   "secret"
      t.text     "raw_info"
      t.datetime "created_at"
      t.datetime "updated_at"
    end
    
    create_table "core_categories", force: true do |t|
      t.string   "name",                        null: false
      t.string   "entity_type", default: "",    null: false
      t.integer  "parent_id"
      t.boolean  "hidden",      default: false, null: false
      t.string   "slug",                        null: false
      t.integer  "sort",        default: 0,     null: false
      t.text     "desc1"
      t.text     "desc2"
      t.text     "desc3"
      t.string   "image_path"
      t.datetime "created_at"
      t.datetime "updated_at"
    end
    
    create_table "core_attributes", force: true do |t|
      t.string   "name",                        null: false
      t.string   "entity_type", default: "",    null: false
      t.string   "notes"
      t.boolean  "hidden",      default: false, null: false
      t.string   "metadata"
      t.string   "data_type",                   null: false
      t.integer  "sort",                        null: false
      t.datetime "created_at"
      t.datetime "updated_at"
    end
    
    create_table "core_logins", force: true do |t|
      t.timestamp "timestamp",  null: false
      t.string    "source"
      t.integer   "user_id",    null: false
      t.string    "ip_address", null: false
      t.string    "user_agent", null: false
    end

    add_index "core_logins", ["user_id"], name: "index_logins_on_user_id", using: :btree
    
    create_table "core_notification_statuses", force: true do |t|
      t.integer  "notification_id", null: false
      t.integer  "user_id",         null: false
      t.datetime "view_time",       null: false
      t.datetime "dismiss_time"
      t.datetime "created_at"
      t.datetime "updated_at"
    end

    create_table "core_notifications", force: true do |t|
      t.string   "title",          null: false
      t.datetime "start_time",     null: false
      t.datetime "expire_time",    null: false
      t.integer  "user_id"
      t.boolean  "web_delivery",   null: false
      t.boolean  "email_delivery", null: false
      t.boolean  "sms_delivery",   null: false
      t.text     "message",        null: false
      t.datetime "created_at"
      t.datetime "updated_at"
    end
    
    
    create_table "core_permissions", force: true do |t|
      t.string   "section",    null: false
      t.string   "resource",   null: false
      t.string   "action",     null: false
      t.datetime "created_at"
      t.datetime "updated_at"
    end
    
    create_table "core_role_permissions", force: true do |t|
      t.integer "role_id",       null: false
      t.integer "permission_id", null: false
    end

    add_index "core_role_permissions", ["permission_id"], name: "index_role_permissions_on_permission_id", using: :btree
    add_index "core_role_permissions", ["role_id"], name: "index_role_permissions_on_role_id", using: :btree

    create_table "core_roles", force: true do |t|
      t.string   "name",       null: false
      t.boolean  "default",    null: false
      t.boolean  "super_user", null: false
      t.datetime "created_at"
      t.datetime "updated_at"
    end
    
    create_table "core_settings", force: true do |t|
      t.string   "section",     default: "", null: false
      t.string   "key",                      null: false
      t.string   "value",                    null: false
      t.string   "value_type",  default: "", null: false
      t.text     "description"
      t.datetime "created_at"
      t.datetime "updated_at"
    end
    
    create_table "core_temporary_tokens", force: true do |t|
      t.integer  "user_id"
      t.string   "value"
      t.datetime "expires"
      t.datetime "created_at"
      t.datetime "updated_at"
    end

    add_index "core_temporary_tokens", ["user_id"], name: "index_temporary_tokens_on_user_id", using: :btree
    
    create_table "core_users", force: true do |t|
      t.integer  "affiliate_id"
      t.integer  "role_id",                      null: false
      t.string   "email",                        null: false
      t.string   "password_digest"
      t.string   "name",                         null: false
      t.string   "phone"
      t.date     "birth_date"
      t.string   "gender"
      t.string   "time_zone"
      t.string   "locale"
      t.string   "location"
      t.string   "avatar_url"
      t.string   "pin"
      t.integer  "referred_by"
      t.string   "referral_key"
      t.integer  "referral_clicks",  default: 0, null: false
      t.integer  "referral_signups", default: 0, null: false
      t.string   "status", limit: 16
      t.boolean  "vip"
      t.datetime "created_at"
      t.datetime "updated_at"
    end
    
  end
end
