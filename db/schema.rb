# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# This file is the source Rails uses to define your schema when running `bin/rails
# db:schema:load`. When creating a new database, `bin/rails db:schema:load` tends to
# be faster and is potentially less error prone than running all of your
# migrations from scratch. Old migrations may fail to apply correctly if those
# migrations use external dependencies or application code.
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema[7.0].define(version: 2023_11_23_010638) do
  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "action_text_rich_texts", force: :cascade do |t|
    t.string "name", null: false
    t.text "body"
    t.string "record_type", null: false
    t.bigint "record_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["record_type", "record_id", "name"], name: "index_action_text_rich_texts_uniqueness", unique: true
  end

  create_table "active_storage_attachments", force: :cascade do |t|
    t.string "name", null: false
    t.string "record_type", null: false
    t.bigint "record_id", null: false
    t.bigint "blob_id", null: false
    t.datetime "created_at", null: false
    t.index ["blob_id"], name: "index_active_storage_attachments_on_blob_id"
    t.index ["record_type", "record_id", "name", "blob_id"], name: "index_active_storage_attachments_uniqueness", unique: true
  end

  create_table "active_storage_blobs", force: :cascade do |t|
    t.string "key", null: false
    t.string "filename", null: false
    t.string "content_type"
    t.text "metadata"
    t.string "service_name", null: false
    t.bigint "byte_size", null: false
    t.string "checksum"
    t.datetime "created_at", null: false
    t.index ["key"], name: "index_active_storage_blobs_on_key", unique: true
  end

  create_table "active_storage_variant_records", force: :cascade do |t|
    t.bigint "blob_id", null: false
    t.string "variation_digest", null: false
    t.index ["blob_id", "variation_digest"], name: "index_active_storage_variant_records_uniqueness", unique: true
  end

  create_table "audits", force: :cascade do |t|
    t.integer "auditable_id"
    t.string "auditable_type"
    t.integer "associated_id"
    t.string "associated_type"
    t.integer "user_id"
    t.string "user_type"
    t.string "username"
    t.string "action"
    t.jsonb "audited_changes"
    t.integer "version", default: 0
    t.string "comment"
    t.string "remote_address"
    t.string "request_uuid"
    t.datetime "created_at"
    t.index ["associated_type", "associated_id"], name: "associated_index"
    t.index ["auditable_type", "auditable_id", "version"], name: "auditable_index"
    t.index ["created_at"], name: "index_audits_on_created_at"
    t.index ["request_uuid"], name: "index_audits_on_request_uuid"
    t.index ["user_id", "user_type"], name: "user_index"
  end

  create_table "blogs", force: :cascade do |t|
    t.bigint "user_id"
    t.integer "status", default: 0
    t.string "title"
    t.string "slug"
    t.datetime "datetime_to_publish"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "meta_description"
    t.string "meta_keywords"
    t.index ["title"], name: "index_blogs_on_title"
    t.index ["user_id"], name: "index_blogs_on_user_id"
  end

  create_table "campaigns", force: :cascade do |t|
    t.bigint "channel_id"
    t.string "name"
    t.string "tag"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "communication_type", default: 0
    t.index ["channel_id"], name: "index_campaigns_on_channel_id"
  end

  create_table "channels", force: :cascade do |t|
    t.string "name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "mailing_lists", force: :cascade do |t|
    t.string "name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "orders", force: :cascade do |t|
    t.integer "amount_in_cents"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "user_id"
    t.index ["user_id"], name: "index_orders_on_user_id"
  end

  create_table "product_orders", force: :cascade do |t|
    t.bigint "order_id"
    t.bigint "product_id"
    t.integer "quantity"
    t.integer "amount_in_cents"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "price_in_cents", default: 0
    t.index ["order_id"], name: "index_product_orders_on_order_id"
    t.index ["product_id"], name: "index_product_orders_on_product_id"
  end

  create_table "products", force: :cascade do |t|
    t.string "name"
    t.string "sku"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "price_in_cents", default: 0
    t.integer "purchase_type", default: 0
    t.integer "billing_type", default: 0
    t.string "stripe_product_api_id"
    t.boolean "for_sale", default: false
    t.string "meta_description"
    t.string "meta_keywords"
    t.string "stripe_product_id"
    t.string "stripe_price_id"
    t.index ["for_sale"], name: "index_products_on_for_sale"
    t.index ["name"], name: "index_products_on_name"
    t.index ["sku"], name: "index_products_on_sku"
    t.index ["stripe_product_id"], name: "index_products_on_stripe_product_id"
  end

  create_table "subscribers", force: :cascade do |t|
    t.bigint "mailing_list_id"
    t.string "email"
    t.string "first_name"
    t.string "last_name"
    t.string "mobile_number"
    t.string "mobile_number_country_code"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["mailing_list_id"], name: "index_subscribers_on_mailing_list_id"
  end

  create_table "subscriptions", force: :cascade do |t|
    t.bigint "user_id"
    t.bigint "product_id"
    t.integer "status"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "order_id"
    t.string "stripe_subscription_id"
    t.index ["product_id"], name: "index_subscriptions_on_product_id"
    t.index ["stripe_subscription_id"], name: "index_subscriptions_on_stripe_subscription_id"
    t.index ["user_id"], name: "index_subscriptions_on_user_id"
  end

  create_table "transactions", force: :cascade do |t|
    t.bigint "user_id"
    t.integer "status", default: 0
    t.string "token"
    t.integer "price_in_cents"
    t.json "history", default: []
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.datetime "date_cleared_funds"
    t.string "stripe_client_secret"
    t.string "stripe_payment_intent"
    t.integer "order_id"
    t.integer "subscription_id"
    t.string "stripe_payment_method"
    t.integer "campaign_id"
    t.index ["campaign_id"], name: "index_transactions_on_campaign_id"
    t.index ["order_id"], name: "index_transactions_on_order_id"
    t.index ["status"], name: "index_transactions_on_status"
    t.index ["stripe_client_secret"], name: "index_transactions_on_stripe_client_secret"
    t.index ["stripe_payment_intent"], name: "index_transactions_on_stripe_payment_intent"
    t.index ["subscription_id"], name: "index_transactions_on_subscription_id"
    t.index ["user_id"], name: "index_transactions_on_user_id"
  end

  create_table "users", force: :cascade do |t|
    t.string "email", default: "", null: false
    t.string "encrypted_password", default: "", null: false
    t.string "first_name", default: "", null: false
    t.string "last_name", default: "", null: false
    t.string "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer "sign_in_count", default: 0, null: false
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.string "current_sign_in_ip"
    t.string "last_sign_in_ip"
    t.string "confirmation_token"
    t.datetime "confirmed_at"
    t.datetime "confirmation_sent_at"
    t.string "unconfirmed_email"
    t.integer "failed_attempts", default: 0, null: false
    t.string "unlock_token"
    t.datetime "locked_at"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "one_time_code"
    t.integer "role", default: 0
    t.string "stripe_customer_id"
    t.string "stripe_payment_method"
    t.integer "campaign_id"
    t.index ["campaign_id"], name: "index_users_on_campaign_id"
    t.index ["email"], name: "index_users_on_email", unique: true
    t.index ["one_time_code"], name: "index_users_on_one_time_code"
    t.index ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true
  end

  add_foreign_key "active_storage_attachments", "active_storage_blobs", column: "blob_id"
  add_foreign_key "active_storage_variant_records", "active_storage_blobs", column: "blob_id"
end
