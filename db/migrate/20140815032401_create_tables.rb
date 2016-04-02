class CreateTables < ActiveRecord::Migration
  def change
    
    create_table "core_affiliate_categories", force: :cascade do |t|
      t.integer "affiliate_id", limit: 4, null: false
      t.integer "category_id",  limit: 4, null: false
    end

    add_index "core_affiliate_categories", ["affiliate_id"], name: "index_affiliate_categories_on_affiliate_id", using: :btree
    add_index "core_affiliate_categories", ["category_id"], name: "index_affiliate_categories_on_category_id", using: :btree

    create_table "core_affiliates", force: :cascade do |t|
      t.string   "name",           limit: 255,                   null: false
      t.string   "code",           limit: 255
      t.string   "slug",           limit: 255,   default: "",    null: false
      t.boolean  "featured",                     default: false, null: false
      t.boolean  "active",                       default: false, null: false
      t.string   "contact_person", limit: 255
      t.string   "street1",        limit: 255
      t.string   "street2",        limit: 255
      t.string   "city",           limit: 255
      t.string   "state",          limit: 255
      t.string   "zip",            limit: 255
      t.string   "country",        limit: 255
      t.string   "phone",          limit: 255
      t.string   "fax",            limit: 255
      t.string   "email",          limit: 255
      t.string   "website",        limit: 255
      t.string   "logo",           limit: 255
      t.text     "description",    limit: 65535
      t.datetime "created_at"
      t.datetime "updated_at"
      t.string   "payment_terms",  limit: 255
      t.string   "facebook_page",  limit: 255
      t.string   "summary",        limit: 255
      t.string   "tax_id",         limit: 255
    end

    create_table "core_authorizations", force: :cascade do |t|
      t.integer  "user_id",    limit: 4
      t.string   "provider",   limit: 255
      t.string   "uid",        limit: 255
      t.string   "name",       limit: 255
      t.text     "token",      limit: 65535
      t.string   "secret",     limit: 255
      t.text     "raw_info",   limit: 65535
      t.datetime "created_at"
      t.datetime "updated_at"
    end

    create_table "core_categories", force: :cascade do |t|
      t.string   "name",        limit: 255,                   null: false
      t.string   "entity_type", limit: 255,   default: "",    null: false
      t.integer  "parent_id",   limit: 4
      t.boolean  "hidden",                    default: false, null: false
      t.string   "slug",        limit: 255,                   null: false
      t.integer  "sort",        limit: 4,     default: 0,     null: false
      t.text     "desc1",       limit: 65535
      t.text     "desc2",       limit: 65535
      t.text     "desc3",       limit: 65535
      t.string   "image_path",  limit: 255
      t.datetime "created_at"
      t.datetime "updated_at"
    end

    create_table "core_domains", force: :cascade do |t|
      t.string   "name",       limit: 255,                 null: false
      t.string   "url",        limit: 255,                 null: false
      t.boolean  "default",                default: false, null: false
      t.datetime "created_at",                             null: false
      t.datetime "updated_at",                             null: false
      t.string   "data1",      limit: 255
      t.string   "data2",      limit: 255
    end

    create_table "core_logins", force: :cascade do |t|
      t.datetime "timestamp",              null: false
      t.string   "source",     limit: 255
      t.integer  "user_id",    limit: 4,   null: false
      t.string   "ip_address", limit: 255, null: false
      t.string   "user_agent", limit: 255, null: false
    end

    add_index "core_logins", ["user_id"], name: "index_logins_on_user_id", using: :btree

    create_table "core_notification_statuses", force: :cascade do |t|
      t.integer  "notification_id", limit: 4, null: false
      t.integer  "user_id",         limit: 4, null: false
      t.datetime "view_time",                 null: false
      t.datetime "dismiss_time"
      t.datetime "created_at"
      t.datetime "updated_at"
    end

    create_table "core_notifications", force: :cascade do |t|
      t.string   "title",          limit: 255,   null: false
      t.datetime "start_time",                   null: false
      t.datetime "expire_time",                  null: false
      t.integer  "user_id",        limit: 4
      t.boolean  "web_delivery",                 null: false
      t.boolean  "email_delivery",               null: false
      t.boolean  "sms_delivery",                 null: false
      t.text     "message",        limit: 65535, null: false
      t.datetime "created_at"
      t.datetime "updated_at"
    end

    create_table "core_permissions", force: :cascade do |t|
      t.string   "section",    limit: 255, null: false
      t.string   "resource",   limit: 255, null: false
      t.string   "action",     limit: 255, null: false
      t.datetime "created_at"
      t.datetime "updated_at"
    end

    create_table "core_role_permissions", force: :cascade do |t|
      t.integer "role_id",       limit: 4, null: false
      t.integer "permission_id", limit: 4, null: false
    end

    add_index "core_role_permissions", ["permission_id"], name: "index_role_permissions_on_permission_id", using: :btree
    add_index "core_role_permissions", ["role_id"], name: "index_role_permissions_on_role_id", using: :btree

    create_table "core_roles", force: :cascade do |t|
      t.string   "name",       limit: 255, null: false
      t.boolean  "default",                null: false
      t.boolean  "super_user",             null: false
      t.datetime "created_at"
      t.datetime "updated_at"
    end

    create_table "core_search_paths", force: :cascade do |t|
      t.string   "short_code",  limit: 255, null: false
      t.string   "url",         limit: 255, null: false
      t.string   "description", limit: 255, null: false
      t.datetime "created_at"
      t.datetime "updated_at"
    end

    create_table "core_settings", force: :cascade do |t|
      t.string   "section",     limit: 255,   default: "", null: false
      t.string   "key",         limit: 255,                null: false
      t.string   "value",       limit: 255,                null: false
      t.string   "value_type",  limit: 255,   default: "", null: false
      t.text     "description", limit: 65535
      t.datetime "created_at"
      t.datetime "updated_at"
      t.integer  "domain_id",   limit: 4,                  null: false
    end

    create_table "core_temporary_tokens", force: :cascade do |t|
      t.integer  "user_id",    limit: 4
      t.string   "value",      limit: 255
      t.datetime "expires"
      t.datetime "created_at"
      t.datetime "updated_at"
    end

    add_index "core_temporary_tokens", ["user_id"], name: "index_temporary_tokens_on_user_id", using: :btree

    create_table "core_users", force: :cascade do |t|
      t.integer  "domain_id",            limit: 4,                                       null: false
      t.integer  "affiliate_id",         limit: 4
      t.integer  "role_id",              limit: 4,                                       null: false
      t.string   "status",               limit: 32
      t.string   "email",                limit: 255,                                     null: false
      t.string   "password_digest",      limit: 255
      t.string   "name",                 limit: 255,                                     null: false
      t.string   "phone",                limit: 255
      t.date     "birth_date"
      t.string   "gender",               limit: 255
      t.string   "time_zone",            limit: 255
      t.string   "locale",               limit: 255
      t.string   "location",             limit: 255
      t.string   "avatar_url",           limit: 255
      t.string   "pin",                  limit: 255
      t.decimal  "replenishment_amount",             precision: 6, scale: 2
      t.integer  "referred_by",          limit: 4
      t.string   "referral_key",         limit: 255
      t.integer  "referral_clicks",      limit: 4,                           default: 0, null: false
      t.integer  "referral_signups",     limit: 4,                           default: 0, null: false
      t.boolean  "vip"
      t.string   "data1",                limit: 255
      t.string   "data2",                limit: 255
      t.datetime "created_at"
      t.datetime "updated_at"
    end
    
  end
end
