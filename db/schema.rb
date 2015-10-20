ActiveRecord::Schema.define(version: 1) do

  create_table "activities", force: :cascade do |t|
    t.integer  "trackable_id",   limit: 4
    t.string   "trackable_type", limit: 255
    t.integer  "owner_id",       limit: 4
    t.string   "owner_type",     limit: 255
    t.string   "key",            limit: 255
    t.text     "parameters",     limit: 65535
    t.integer  "recipient_id",   limit: 4
    t.string   "recipient_type", limit: 255
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "activities", ["owner_id", "owner_type"], name: "index_activities_on_owner_id_and_owner_type", using: :btree
  add_index "activities", ["recipient_id", "recipient_type"], name: "index_activities_on_recipient_id_and_recipient_type", using: :btree
  add_index "activities", ["trackable_id", "trackable_type"], name: "index_activities_on_trackable_id_and_trackable_type", using: :btree

  create_table "artwork_proofs", force: :cascade do |t|
    t.integer  "artwork_id", limit: 4
    t.integer  "proof_id",   limit: 4
    t.datetime "created_at"
    t.datetime "updated_at"
    t.datetime "deleted_at"
  end

  create_table "artwork_request_artworks", force: :cascade do |t|
    t.integer  "artwork_request_id", limit: 4
    t.integer  "artwork_id",         limit: 4
    t.datetime "created_at"
    t.datetime "updated_at"
    t.datetime "deleted_at"
  end

  create_table "artwork_request_imprints", force: :cascade do |t|
    t.integer "artwork_request_id", limit: 4
    t.integer "imprint_id",         limit: 4
  end

  create_table "artwork_request_ink_colors", force: :cascade do |t|
    t.integer  "artwork_request_id", limit: 4
    t.integer  "ink_color_id",       limit: 4
    t.datetime "created_at"
    t.datetime "updated_at"
    t.datetime "deleted_at"
  end

  create_table "artwork_request_jobs", force: :cascade do |t|
    t.integer  "artwork_request_id", limit: 4
    t.integer  "job_id",             limit: 4
    t.datetime "created_at"
    t.datetime "updated_at"
    t.datetime "deleted_at"
  end

  create_table "artwork_requests", force: :cascade do |t|
    t.text     "description",       limit: 65535
    t.integer  "artist_id",         limit: 4
    t.integer  "imprint_method_id", limit: 4
    t.integer  "print_location_id", limit: 4
    t.integer  "salesperson_id",    limit: 4
    t.datetime "deadline"
    t.string   "artwork_status",    limit: 255
    t.datetime "deleted_at"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "priority",          limit: 255
  end

  create_table "artworks", force: :cascade do |t|
    t.string   "name",                limit: 255
    t.string   "description",         limit: 255
    t.integer  "artist_id",           limit: 4
    t.datetime "deleted_at"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "artwork_id",          limit: 4
    t.integer  "preview_id",          limit: 4
    t.string   "local_file_location", limit: 255
  end

  create_table "assets", force: :cascade do |t|
    t.string   "file_file_name",       limit: 255
    t.string   "file_content_type",    limit: 255
    t.integer  "file_file_size",       limit: 4
    t.datetime "file_updated_at"
    t.string   "description",          limit: 255
    t.integer  "assetable_id",         limit: 4
    t.string   "assetable_type",       limit: 255
    t.datetime "deleted_at"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "allowed_content_type", limit: 255
  end

  create_table "brands", force: :cascade do |t|
    t.string   "name",       limit: 255
    t.string   "sku",        limit: 255
    t.datetime "created_at"
    t.datetime "updated_at"
    t.datetime "deleted_at"
    t.boolean  "retail",                 default: false
  end

  add_index "brands", ["deleted_at"], name: "index_brands_on_deleted_at", using: :btree
  add_index "brands", ["retail"], name: "index_brands_on_retail", using: :btree

  create_table "colors", force: :cascade do |t|
    t.string   "name",       limit: 255
    t.string   "sku",        limit: 255
    t.datetime "created_at"
    t.datetime "updated_at"
    t.datetime "deleted_at"
    t.boolean  "retail",                 default: false
    t.string   "hexcode",    limit: 255
  end

  add_index "colors", ["deleted_at"], name: "index_colors_on_deleted_at", using: :btree
  add_index "colors", ["retail"], name: "index_colors_on_retail", using: :btree

  create_table "comments", force: :cascade do |t|
    t.string   "title",            limit: 140,   default: ""
    t.text     "comment",          limit: 65535
    t.integer  "commentable_id",   limit: 4
    t.string   "commentable_type", limit: 255
    t.integer  "user_id",          limit: 4
    t.string   "role",             limit: 255,   default: "comments"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "comments", ["commentable_id"], name: "index_comments_on_commentable_id", using: :btree
  add_index "comments", ["commentable_type"], name: "index_comments_on_commentable_type", using: :btree
  add_index "comments", ["user_id"], name: "index_comments_on_user_id", using: :btree

  create_table "coordinate_imprintables", force: :cascade do |t|
    t.integer  "coordinate_id",  limit: 4
    t.integer  "imprintable_id", limit: 4
    t.datetime "deleted_at"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "coordinate_imprintables", ["coordinate_id", "imprintable_id"], name: "coordinate_imprintable_index", using: :btree

  create_table "coupons", force: :cascade do |t|
    t.string   "code",        limit: 255
    t.string   "name",        limit: 255
    t.string   "calculator",  limit: 255
    t.decimal  "value",                   precision: 10
    t.datetime "valid_until"
    t.datetime "valid_from"
    t.datetime "created_at",                             null: false
    t.datetime "updated_at",                             null: false
  end

  add_index "coupons", ["code"], name: "index_coupons_on_code", using: :btree

  create_table "customer_uploads", force: :cascade do |t|
    t.string   "filename",         limit: 255
    t.string   "url",              limit: 255
    t.integer  "quote_request_id", limit: 4
    t.datetime "created_at",                   null: false
    t.datetime "updated_at",                   null: false
  end

  create_table "discounts", force: :cascade do |t|
    t.integer  "discountable_id",   limit: 4
    t.string   "discountable_type", limit: 255
    t.text     "reason",            limit: 65535
    t.string   "discount_method",   limit: 255
    t.string   "transaction_id",    limit: 255
    t.integer  "user_id",           limit: 4
    t.integer  "applicator_id",     limit: 4
    t.string   "applicator_type",   limit: 255
    t.decimal  "amount",                          precision: 10
    t.integer  "order_id",          limit: 4
    t.datetime "deleted_at"
    t.datetime "created_at",                                     null: false
    t.datetime "updated_at",                                     null: false
  end

  create_table "email_templates", force: :cascade do |t|
    t.string   "subject",        limit: 255
    t.string   "from",           limit: 255
    t.string   "bcc",            limit: 255
    t.string   "cc",             limit: 255
    t.text     "body",           limit: 65535
    t.datetime "deleted_at"
    t.string   "template_type",  limit: 255
    t.string   "name",           limit: 255
    t.text     "plaintext_body", limit: 65535
    t.string   "to",             limit: 255
  end

  create_table "emails", force: :cascade do |t|
    t.string   "subject",        limit: 255
    t.text     "body",           limit: 65535
    t.string   "to",             limit: 255
    t.string   "from",           limit: 255
    t.string   "cc",             limit: 255
    t.integer  "emailable_id",   limit: 4
    t.string   "emailable_type", limit: 255
    t.datetime "deleted_at"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "bcc",            limit: 255
    t.text     "plaintext_body", limit: 65535
    t.boolean  "freshdesk"
  end

  create_table "freshdesk_local_contacts", force: :cascade do |t|
    t.string   "name",         limit: 255
    t.integer  "freshdesk_id", limit: 4
    t.string   "email",        limit: 255
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "imprint_method_imprintables", force: :cascade do |t|
    t.integer  "imprint_method_id", limit: 4
    t.integer  "imprintable_id",    limit: 4
    t.datetime "created_at"
    t.datetime "updated_at"
    t.datetime "deleted_at"
  end

  add_index "imprint_method_imprintables", ["imprintable_id", "imprint_method_id"], name: "imprint_method_imprintables_index", using: :btree

  create_table "imprint_method_ink_colors", force: :cascade do |t|
    t.integer  "imprint_method_id", limit: 4
    t.integer  "ink_color_id",      limit: 4
    t.datetime "created_at",                  null: false
    t.datetime "updated_at",                  null: false
  end

  create_table "imprint_methods", force: :cascade do |t|
    t.string   "name",       limit: 255
    t.datetime "deleted_at"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.boolean  "deletable",              default: true
  end

  add_index "imprint_methods", ["deleted_at"], name: "index_imprint_methods_on_deleted_at", using: :btree

  create_table "imprintable_categories", force: :cascade do |t|
    t.string   "name",           limit: 255
    t.integer  "imprintable_id", limit: 4
    t.datetime "deleted_at"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "imprintable_groups", force: :cascade do |t|
    t.string "name",        limit: 255
    t.text   "description", limit: 65535
  end

  create_table "imprintable_imprintable_groups", force: :cascade do |t|
    t.integer "imprintable_id",       limit: 4
    t.integer "imprintable_group_id", limit: 4
    t.integer "tier",                 limit: 4
    t.boolean "default"
  end

  create_table "imprintable_photos", force: :cascade do |t|
    t.integer  "color_id",       limit: 4
    t.integer  "imprintable_id", limit: 4
    t.boolean  "default"
    t.datetime "created_at",               null: false
    t.datetime "updated_at",               null: false
  end

  create_table "imprintable_stores", force: :cascade do |t|
    t.integer  "imprintable_id", limit: 4
    t.integer  "store_id",       limit: 4
    t.datetime "created_at"
    t.datetime "updated_at"
    t.datetime "deleted_at"
  end

  add_index "imprintable_stores", ["imprintable_id", "store_id"], name: "index_imprintable_stores_on_imprintable_id_and_store_id", using: :btree

  create_table "imprintable_variants", force: :cascade do |t|
    t.integer  "imprintable_id", limit: 4
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "size_id",        limit: 4
    t.integer  "color_id",       limit: 4
    t.datetime "deleted_at"
    t.decimal  "weight",                   precision: 10, scale: 1
  end

  add_index "imprintable_variants", ["deleted_at"], name: "index_imprintable_variants_on_deleted_at", using: :btree

  create_table "imprintables", force: :cascade do |t|
    t.datetime "created_at"
    t.datetime "updated_at"
    t.boolean  "flashable"
    t.text     "special_considerations", limit: 65535
    t.boolean  "polyester"
    t.string   "sizing_category",        limit: 255
    t.datetime "deleted_at"
    t.text     "proofing_template_name", limit: 65535
    t.string   "material",               limit: 255
    t.boolean  "standard_offering"
    t.string   "main_supplier",          limit: 255
    t.string   "supplier_link",          limit: 255
    t.string   "weight",                 limit: 255
    t.decimal  "base_price",                           precision: 10, scale: 2
    t.decimal  "xxl_price",                            precision: 10, scale: 2
    t.decimal  "xxxl_price",                           precision: 10, scale: 2
    t.decimal  "xxxxl_price",                          precision: 10, scale: 2
    t.decimal  "xxxxxl_price",                         precision: 10, scale: 2
    t.decimal  "xxxxxxl_price",                        precision: 10, scale: 2
    t.string   "style_name",             limit: 255
    t.string   "style_catalog_no",       limit: 255
    t.text     "style_description",      limit: 65535
    t.string   "sku",                    limit: 255
    t.boolean  "retail",                                                        default: false
    t.integer  "brand_id",               limit: 4
    t.decimal  "max_imprint_width",                    precision: 8,  scale: 2
    t.decimal  "max_imprint_height",                   precision: 8,  scale: 2
    t.string   "common_name",            limit: 255
    t.decimal  "xxl_upcharge",                         precision: 10, scale: 2
    t.decimal  "xxxl_upcharge",                        precision: 10, scale: 2
    t.decimal  "xxxxl_upcharge",                       precision: 10, scale: 2
    t.decimal  "xxxxxl_upcharge",                      precision: 10, scale: 2
    t.decimal  "xxxxxxl_upcharge",                     precision: 10, scale: 2
    t.decimal  "base_upcharge",                        precision: 10, scale: 2
    t.boolean  "discontinued",                                                  default: false
    t.string   "water_resistance_level", limit: 255
    t.string   "sleeve_type",            limit: 255
    t.string   "sleeve_length",          limit: 255
    t.string   "neck_style",             limit: 255
    t.string   "neck_size",              limit: 255
    t.string   "fabric_type",            limit: 255
    t.boolean  "is_stain_resistant"
    t.string   "fit_type",               limit: 255
    t.string   "fabric_wash",            limit: 255
    t.string   "department_name",        limit: 255
    t.string   "chest_size",             limit: 255
    t.decimal  "package_height",                       precision: 10
    t.decimal  "package_width",                        precision: 10
    t.decimal  "package_length",                       precision: 10
    t.string   "tag",                    limit: 255,                            default: "Not Specified"
  end

  add_index "imprintables", ["deleted_at"], name: "index_imprintables_on_deleted_at", using: :btree
  add_index "imprintables", ["main_supplier"], name: "index_imprintables_on_main_supplier", using: :btree

  create_table "imprints", force: :cascade do |t|
    t.integer  "print_location_id", limit: 4
    t.integer  "job_id",            limit: 4
    t.decimal  "ideal_width",                     precision: 10
    t.decimal  "ideal_height",                    precision: 10
    t.datetime "deleted_at"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.boolean  "has_name_number"
    t.integer  "name_number_id",    limit: 4
    t.string   "name_format",       limit: 255
    t.string   "number_format",     limit: 255
    t.text     "description",       limit: 65535
    t.integer  "softwear_prod_id",  limit: 4
  end

  create_table "in_store_credits", force: :cascade do |t|
    t.string   "name",                limit: 255
    t.string   "customer_first_name", limit: 255
    t.string   "customer_last_name",  limit: 255
    t.string   "customer_email",      limit: 255
    t.decimal  "amount",                            precision: 10
    t.text     "description",         limit: 65535
    t.integer  "user_id",             limit: 4
    t.datetime "valid_until"
    t.datetime "created_at",                                       null: false
    t.datetime "updated_at",                                       null: false
  end

  create_table "ink_colors", force: :cascade do |t|
    t.string   "name",       limit: 255
    t.datetime "deleted_at"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.boolean  "custom"
  end

  add_index "ink_colors", ["deleted_at"], name: "index_ink_colors_on_deleted_at", using: :btree

  create_table "jobs", force: :cascade do |t|
    t.string   "name",             limit: 255
    t.text     "description",      limit: 65535
    t.integer  "jobbable_id",      limit: 4
    t.datetime "deleted_at"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.boolean  "collapsed"
    t.string   "jobbable_type",    limit: 255
    t.integer  "softwear_prod_id", limit: 4
  end

  add_index "jobs", ["deleted_at"], name: "index_jobs_on_deleted_at", using: :btree

  create_table "line_item_groups", force: :cascade do |t|
    t.string   "name",        limit: 255
    t.string   "description", limit: 255
    t.integer  "quote_id",    limit: 4
    t.datetime "deleted_at"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "line_item_groups", ["quote_id"], name: "index_line_item_groups_on_quote_id", using: :btree

  create_table "line_item_templates", force: :cascade do |t|
    t.string   "name",        limit: 255
    t.text     "description", limit: 65535
    t.string   "url",         limit: 255
    t.decimal  "unit_price",                precision: 10, scale: 2
    t.datetime "created_at",                                         null: false
    t.datetime "updated_at",                                         null: false
  end

  create_table "line_items", force: :cascade do |t|
    t.string   "name",                    limit: 255
    t.integer  "quantity",                limit: 4
    t.boolean  "taxable",                                                        default: true
    t.text     "description",             limit: 65535
    t.datetime "deleted_at"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.decimal  "unit_price",                            precision: 10, scale: 2
    t.integer  "line_itemable_id",        limit: 4
    t.string   "line_itemable_type",      limit: 255
    t.string   "url",                     limit: 255
    t.decimal  "decoration_price",                      precision: 10, scale: 2
    t.decimal  "imprintable_price",                     precision: 10, scale: 2
    t.integer  "tier",                    limit: 4
    t.integer  "sort_order",              limit: 4
    t.integer  "imprintable_object_id",   limit: 4
    t.string   "imprintable_object_type", limit: 255
  end

  add_index "line_items", ["line_itemable_id", "line_itemable_type"], name: "index_line_items_on_line_itemable_id_and_line_itemable_type", using: :btree

  create_table "name_numbers", force: :cascade do |t|
    t.string  "name",                   limit: 255
    t.string  "number",                 limit: 255
    t.integer "imprint_id",             limit: 4
    t.integer "imprintable_variant_id", limit: 4
  end

  create_table "order_quotes", force: :cascade do |t|
    t.integer  "order_id",   limit: 4
    t.integer  "quote_id",   limit: 4
    t.datetime "deleted_at"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "orders", force: :cascade do |t|
    t.string   "email",                     limit: 255
    t.string   "firstname",                 limit: 255
    t.string   "lastname",                  limit: 255
    t.string   "company",                   limit: 255
    t.string   "twitter",                   limit: 255
    t.string   "name",                      limit: 255
    t.string   "po",                        limit: 255
    t.datetime "in_hand_by"
    t.string   "terms",                     limit: 255
    t.boolean  "tax_exempt"
    t.string   "tax_id_number",             limit: 255
    t.string   "delivery_method",           limit: 255
    t.datetime "deleted_at"
    t.string   "phone_number",              limit: 255
    t.datetime "created_at"
    t.datetime "updated_at"
    t.decimal  "commission_amount",                     precision: 10, scale: 2
    t.integer  "store_id",                  limit: 4
    t.integer  "salesperson_id",            limit: 4
    t.decimal  "shipping_price",                        precision: 10, scale: 2, default: 0.0
    t.string   "invoice_state",             limit: 255
    t.string   "production_state",          limit: 255
    t.string   "notification_state",        limit: 255
    t.integer  "freshdesk_proof_ticket_id", limit: 4
    t.integer  "softwear_prod_id",          limit: 4
  end

  add_index "orders", ["deleted_at"], name: "index_orders_on_deleted_at", using: :btree

  create_table "payments", force: :cascade do |t|
    t.integer  "order_id",          limit: 4
    t.integer  "salesperson_id",    limit: 4
    t.integer  "store_id",          limit: 4
    t.boolean  "refunded"
    t.decimal  "amount",                          precision: 10, scale: 2
    t.text     "refund_reason",     limit: 65535
    t.datetime "deleted_at"
    t.string   "cc_invoice_no",     limit: 255
    t.string   "cc_batch_no",       limit: 255
    t.string   "check_dl_no",       limit: 255
    t.string   "check_phone_no",    limit: 255
    t.string   "pp_transaction_id", limit: 255
    t.integer  "payment_method",    limit: 4
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "t_name",            limit: 255
    t.string   "t_company_name",    limit: 255
    t.string   "tf_number",         limit: 255
    t.text     "t_description",     limit: 65535
  end

  create_table "platen_hoops", force: :cascade do |t|
    t.string   "name",       limit: 255
    t.decimal  "max_width",              precision: 10, scale: 2
    t.decimal  "max_height",             precision: 10, scale: 2
    t.datetime "created_at",                                      null: false
    t.datetime "updated_at",                                      null: false
  end

  create_table "print_location_imprintables", force: :cascade do |t|
    t.integer  "imprintable_id",       limit: 4
    t.integer  "print_location_id",    limit: 4
    t.decimal  "max_imprint_width",              precision: 10
    t.decimal  "max_imprint_height",             precision: 10
    t.datetime "created_at",                                              null: false
    t.datetime "updated_at",                                              null: false
    t.decimal  "ideal_imprint_width",            precision: 10, scale: 2
    t.decimal  "ideal_imprint_height",           precision: 10, scale: 2
    t.integer  "platen_hoop_id",       limit: 4
  end

  create_table "print_locations", force: :cascade do |t|
    t.string   "name",              limit: 255
    t.integer  "imprint_method_id", limit: 4
    t.decimal  "max_height",                    precision: 8, scale: 2
    t.decimal  "max_width",                     precision: 8, scale: 2
    t.datetime "deleted_at"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "print_locations", ["deleted_at"], name: "index_print_locations_on_deleted_at", using: :btree
  add_index "print_locations", ["imprint_method_id"], name: "index_print_locations_on_imprint_method_id", using: :btree

  create_table "proofs", force: :cascade do |t|
    t.string   "status",      limit: 255
    t.integer  "order_id",    limit: 4
    t.datetime "approve_by"
    t.datetime "approved_at"
    t.datetime "deleted_at"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "job_id",      limit: 4
  end

  create_table "quote_request_quotes", force: :cascade do |t|
    t.integer  "quote_id",         limit: 4
    t.integer  "quote_request_id", limit: 4
    t.datetime "deleted_at"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "quote_requests", force: :cascade do |t|
    t.string   "name",                      limit: 255
    t.string   "email",                     limit: 255
    t.string   "approx_quantity",           limit: 255
    t.datetime "date_needed"
    t.text     "description",               limit: 65535
    t.string   "source",                    limit: 255
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "salesperson_id",            limit: 4
    t.string   "status",                    limit: 255
    t.string   "reason",                    limit: 255
    t.string   "phone_number",              limit: 255
    t.string   "organization",              limit: 255
    t.integer  "insightly_contact_id",      limit: 4
    t.integer  "insightly_organisation_id", limit: 4
    t.integer  "freshdesk_contact_id",      limit: 4
    t.string   "freshdesk_ticket_id",       limit: 255
  end

  create_table "quotes", force: :cascade do |t|
    t.string   "email",                            limit: 255
    t.string   "phone_number",                     limit: 255
    t.string   "first_name",                       limit: 255
    t.string   "last_name",                        limit: 255
    t.string   "company",                          limit: 255
    t.string   "twitter",                          limit: 255
    t.string   "name",                             limit: 255
    t.datetime "valid_until_date"
    t.datetime "estimated_delivery_date"
    t.integer  "salesperson_id",                   limit: 4
    t.integer  "store_id",                         limit: 4
    t.datetime "deleted_at"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.decimal  "shipping",                                     precision: 10, scale: 2
    t.datetime "initialized_at"
    t.string   "quote_source",                     limit: 255
    t.string   "freshdesk_ticket_id",              limit: 255
    t.boolean  "informal"
    t.integer  "insightly_category_id",            limit: 4
    t.integer  "insightly_probability",            limit: 4
    t.decimal  "insightly_value",                              precision: 10, scale: 2
    t.integer  "insightly_pipeline_id",            limit: 4
    t.integer  "insightly_opportunity_id",         limit: 4
    t.integer  "insightly_bid_tier_id",            limit: 4
    t.boolean  "is_rushed"
    t.integer  "qty",                              limit: 4
    t.boolean  "deadline_is_specified"
    t.integer  "insightly_opportunity_profile_id", limit: 4
    t.decimal  "insightly_bid_amount",                         precision: 10, scale: 2
    t.integer  "insightly_whos_responsible_id",    limit: 4
  end

  create_table "sample_locations", force: :cascade do |t|
    t.integer "imprintable_id", limit: 4
    t.integer "store_id",       limit: 4
  end

  create_table "search_boolean_filters", force: :cascade do |t|
    t.string  "field",  limit: 255
    t.boolean "negate"
    t.boolean "value"
  end

  create_table "search_date_filters", force: :cascade do |t|
    t.string   "field",      limit: 255
    t.boolean  "negate"
    t.datetime "value"
    t.string   "comparator", limit: 1
  end

  create_table "search_filter_groups", force: :cascade do |t|
    t.boolean "all"
  end

  create_table "search_filters", force: :cascade do |t|
    t.integer "filter_holder_id",   limit: 4
    t.string  "filter_holder_type", limit: 255
    t.integer "filter_type_id",     limit: 4
    t.string  "filter_type_type",   limit: 255
  end

  create_table "search_nil_filters", force: :cascade do |t|
    t.string  "field",  limit: 255
    t.boolean "negate"
  end

  create_table "search_number_filters", force: :cascade do |t|
    t.string  "field",      limit: 255
    t.boolean "negate"
    t.decimal "value",                  precision: 10, scale: 2
    t.string  "comparator", limit: 1
  end

  create_table "search_phrase_filters", force: :cascade do |t|
    t.string  "field",  limit: 255
    t.boolean "negate"
    t.string  "value",  limit: 255
  end

  create_table "search_queries", force: :cascade do |t|
    t.integer  "user_id",    limit: 4
    t.string   "name",       limit: 255
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "search_query_fields", force: :cascade do |t|
    t.integer "query_model_id", limit: 4
    t.string  "name",           limit: 255
    t.decimal "boost",                      precision: 10, scale: 2
    t.integer "phrase",         limit: 4
  end

  create_table "search_query_models", force: :cascade do |t|
    t.integer "query_id",         limit: 4
    t.string  "name",             limit: 255
    t.string  "default_fulltext", limit: 255
  end

  create_table "search_reference_filters", force: :cascade do |t|
    t.string  "field",      limit: 255
    t.boolean "negate"
    t.integer "value_id",   limit: 4
    t.string  "value_type", limit: 255
  end

  create_table "search_string_filters", force: :cascade do |t|
    t.string  "field",  limit: 255
    t.boolean "negate"
    t.string  "value",  limit: 255
  end

  create_table "sessions", force: :cascade do |t|
    t.string   "session_id", limit: 255,   null: false
    t.text     "data",       limit: 65535
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "sessions", ["session_id"], name: "index_sessions_on_session_id", unique: true, using: :btree
  add_index "sessions", ["updated_at"], name: "index_sessions_on_updated_at", using: :btree

  create_table "settings", force: :cascade do |t|
    t.string   "name",          limit: 255
    t.string   "val",           limit: 255
    t.string   "encrypted_val", limit: 255
    t.boolean  "encrypted"
    t.datetime "deleted_at"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "shipments", force: :cascade do |t|
    t.integer  "shipping_method_id", limit: 4
    t.integer  "shipped_by_id",      limit: 4
    t.integer  "shippable_id",       limit: 4
    t.string   "shippable_type",     limit: 255
    t.decimal  "shipping_cost",                  precision: 10, scale: 2
    t.datetime "shipped_at"
    t.string   "tracking_number",    limit: 255
    t.string   "status",             limit: 255
    t.string   "name",               limit: 255
    t.string   "company",            limit: 255
    t.string   "attn",               limit: 255
    t.string   "address_1",          limit: 255
    t.string   "address_2",          limit: 255
    t.string   "address_3",          limit: 255
    t.string   "city",               limit: 255
    t.string   "state",              limit: 255
    t.string   "zipcode",            limit: 255
    t.string   "country",            limit: 255
    t.datetime "created_at",                                              null: false
    t.datetime "updated_at",                                              null: false
  end

  create_table "shipping_methods", force: :cascade do |t|
    t.string   "name",         limit: 255
    t.string   "tracking_url", limit: 255
    t.datetime "deleted_at"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "shipping_methods", ["deleted_at"], name: "index_shipping_methods_on_deleted_at", using: :btree

  create_table "sizes", force: :cascade do |t|
    t.string   "name",                   limit: 255
    t.string   "display_value",          limit: 255
    t.string   "sku",                    limit: 255
    t.integer  "sort_order",             limit: 4
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "imprintable_variant_id", limit: 4
    t.datetime "deleted_at"
    t.boolean  "retail",                             default: false
  end

  add_index "sizes", ["deleted_at"], name: "index_sizes_on_deleted_at", using: :btree
  add_index "sizes", ["imprintable_variant_id"], name: "size_imprintable_variant_id_ix", using: :btree
  add_index "sizes", ["retail"], name: "index_sizes_on_retail", using: :btree

  create_table "stores", force: :cascade do |t|
    t.string   "name",       limit: 255
    t.string   "deleted_at", limit: 255
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "stores", ["deleted_at"], name: "index_stores_on_deleted_at", using: :btree

  create_table "taggings", force: :cascade do |t|
    t.integer  "tag_id",        limit: 4
    t.integer  "taggable_id",   limit: 4
    t.string   "taggable_type", limit: 255
    t.integer  "tagger_id",     limit: 4
    t.string   "tagger_type",   limit: 255
    t.string   "context",       limit: 128
    t.datetime "created_at"
  end

  add_index "taggings", ["tag_id", "taggable_id", "taggable_type", "context", "tagger_id", "tagger_type"], name: "taggings_idx", unique: true, using: :btree

  create_table "tags", force: :cascade do |t|
    t.string  "name",           limit: 255
    t.integer "taggings_count", limit: 4,   default: 0
  end

  add_index "tags", ["name"], name: "index_tags_on_name", unique: true, using: :btree

  create_table "users", force: :cascade do |t|
    t.string   "email",                        limit: 255, default: "", null: false
    t.string   "encrypted_password",           limit: 255, default: "", null: false
    t.string   "reset_password_token",         limit: 255
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer  "sign_in_count",                limit: 4,   default: 0,  null: false
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.string   "current_sign_in_ip",           limit: 255
    t.string   "last_sign_in_ip",              limit: 255
    t.string   "confirmation_token",           limit: 255
    t.datetime "confirmed_at"
    t.datetime "confirmation_sent_at"
    t.string   "unconfirmed_email",            limit: 255
    t.integer  "failed_attempts",              limit: 4,   default: 0,  null: false
    t.string   "unlock_token",                 limit: 255
    t.datetime "locked_at"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "first_name",                   limit: 255
    t.string   "last_name",                    limit: 255
    t.datetime "deleted_at"
    t.integer  "store_id",                     limit: 4
    t.string   "authentication_token",         limit: 255
    t.string   "freshdesk_email",              limit: 255
    t.string   "freshdesk_password",           limit: 255
    t.string   "encrypted_freshdesk_password", limit: 255
    t.string   "insightly_api_key",            limit: 255
    t.integer  "profile_picture_id",           limit: 4
    t.integer  "signature_id",                 limit: 4
  end

  add_index "users", ["authentication_token"], name: "index_users_on_authentication_token", using: :btree
  add_index "users", ["confirmation_token"], name: "index_users_on_confirmation_token", unique: true, using: :btree
  add_index "users", ["deleted_at"], name: "index_users_on_deleted_at", using: :btree
  add_index "users", ["email"], name: "index_users_on_email", unique: true, using: :btree
  add_index "users", ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true, using: :btree
  add_index "users", ["unlock_token"], name: "index_users_on_unlock_token", unique: true, using: :btree

  create_table "warning_emails", force: :cascade do |t|
    t.string  "model",     limit: 255
    t.decimal "minutes",               precision: 10, scale: 2
    t.string  "recipient", limit: 255
    t.string  "url",       limit: 255
  end

  create_table "warnings", force: :cascade do |t|
    t.integer  "warnable_id",   limit: 4
    t.string   "warnable_type", limit: 255
    t.string   "source",        limit: 255
    t.text     "message",       limit: 65535
    t.datetime "dismissed_at"
    t.integer  "dismisser_id",  limit: 4
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "crm_artworks", :force => true do |t|
    t.integer  "custom_order_id"
    t.integer  "administrator_id"
    t.integer  "parent_id"
    t.string   "content_type"
    t.string   "filename"
    t.string   "thumbnail"
    t.integer  "size"
    t.integer  "width"
    t.integer  "height"
    t.text     "description"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "crm_artworks", ["administrator_id"], :name => "index_artworks_on_administrator_id"
  add_index "crm_artworks", ["custom_order_id"], :name => "index_artworks_on_custom_order_id"

  create_table "crm_blog_entries", :force => true do |t|
    t.integer  "author_id"
    t.string   "title"
    t.text     "body"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "crm_blog_entries", ["author_id"], :name => "index_blog_entries_on_author_id"

  create_table "crm_brands", :force => true do |t|
    t.string "name"
    t.string "sku_code"
  end

  add_index "crm_brands", ["name"], :name => "index_brands_on_name"
  add_index "crm_brands", ["sku_code"], :name => "index_brands_on_sku_code"

  create_table "crm_comments", :force => true do |t|
    t.string   "title",            :limit => 50, :default => ""
    t.string   "comment",                        :default => ""
    t.datetime "created_at",                                     :null => false
    t.integer  "commentable_id",                 :default => 0,  :null => false
    t.string   "commentable_type", :limit => 15, :default => "", :null => false
    t.integer  "user_id",                        :default => 0,  :null => false
  end

  add_index "crm_comments", ["commentable_id"], :name => "index_comments_on_commentable_id"
  add_index "crm_comments", ["user_id"], :name => "index_comments_on_user_id"

  create_table "crm_inventories", :force => true do |t|
    t.string  "name"
    t.integer "brand_id"
    t.string  "catalog_number"
    t.string  "color"
    t.string  "size"
    t.text    "description"
    t.text    "image"
    t.integer "lbs",                :default => 0
    t.integer "oz",                 :default => 0
    t.integer "sort_order",         :default => 0
    t.integer "inventory_size_id"
    t.integer "inventory_color_id"
    t.integer "inventory_line_id"
    t.integer "retail_stock_level", :default => 0
  end

  add_index "crm_inventories", ["brand_id"], :name => "index_inventories_on_brand_id"
  add_index "crm_inventories", ["catalog_number"], :name => "index_inventories_on_catalog_number"
  add_index "crm_inventories", ["color"], :name => "index_inventories_on_color"
  add_index "crm_inventories", ["inventory_color_id"], :name => "index_inventories_on_inventory_color_id"
  add_index "crm_inventories", ["inventory_line_id"], :name => "index_inventories_on_inventory_line_id"
  add_index "crm_inventories", ["inventory_size_id"], :name => "index_inventories_on_inventory_size_id"
  add_index "crm_inventories", ["name"], :name => "index_inventories_on_name"
  add_index "crm_inventories", ["size"], :name => "index_inventories_on_size"

  create_table "crm_inventories_retail_products", :force => true do |t|
    t.integer "retail_product_id",                                                :null => false
    t.integer "inventory_id",                                                     :null => false
    t.decimal "upcharge",          :precision => 8, :scale => 2, :default => 0.0
  end

  add_index "crm_inventories_retail_products", ["inventory_id"], :name => "index_inventories_retail_products_on_inventory_id"
  add_index "crm_inventories_retail_products", ["retail_product_id"], :name => "index_inventories_retail_products_on_retail_product_id"

  create_table "crm_inventory_colors", :force => true do |t|
    t.string "color"
    t.string "sku_code"
  end

  add_index "crm_inventory_colors", ["sku_code"], :name => "index_inventory_colors_on_sku_code"

  create_table "crm_inventory_lines", :force => true do |t|
    t.integer "brand_id"
    t.string  "catalog_number"
    t.string  "name"
    t.string  "description"
    t.string  "sku_code"
  end

  add_index "crm_inventory_lines", ["brand_id"], :name => "index_inventory_lines_on_brand_id"
  add_index "crm_inventory_lines", ["sku_code"], :name => "index_inventory_lines_on_sku_code"

  create_table "crm_inventory_order_line_items", :force => true do |t|
    t.integer "supplier_location_id"
    t.integer "line_item_id"
    t.integer "inventory_order_id"
  end

  create_table "crm_inventory_orders", :force => true do |t|
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "crm_inventory_sizes", :force => true do |t|
    t.string  "size"
    t.integer "sort_order"
    t.string  "sku_code"
  end

  add_index "crm_inventory_sizes", ["sku_code"], :name => "index_inventory_sizes_on_sku_code"

  create_table "crm_iso_countries", :force => true do |t|
    t.string "iso2"
    t.string "iso3"
    t.string "name"
  end

  create_table "crm_jobs", :force => true do |t|
    t.string   "title"
    t.string   "type"
    t.integer  "custom_order_id"
    t.boolean  "rtp_art_approved",                                        :default => false
    t.boolean  "scheduled",                                               :default => false
    t.datetime "print_date"
    t.boolean  "artwork_burned",                                          :default => false
    t.boolean  "ordered",                                                 :default => false
    t.boolean  "printed",                                                 :default => false
    t.boolean  "inventoried",                                             :default => false
    t.boolean  "sent_to_embroiderer",                                     :default => false
    t.boolean  "received_from_embroiderer",                               :default => false
    t.text     "description"
    t.decimal  "subtotal",                  :precision => 8, :scale => 2
    t.decimal  "tax",                       :precision => 8, :scale => 2
    t.decimal  "total",                     :precision => 8, :scale => 2
    t.decimal  "discounts",                 :precision => 8, :scale => 2
    t.integer  "pieces"
    t.boolean  "films_printed",                                           :default => false
    t.boolean  "art_submitted",                                           :default => false
    t.string   "inventory_location"
    t.string   "inventoried_by"
    t.boolean  "proof_requested",                                         :default => false
    t.integer  "whos_proofing"
    t.boolean  "partially_inventoried",                                   :default => false
    t.boolean  "art_sent_to_embroiderer",                                 :default => false
    t.boolean  "digital_white_ink",                                       :default => false
    t.boolean  "digital_file_generated",                                  :default => false
    t.boolean  "digital_file_requested",                                  :default => false
  end

  add_index "crm_jobs", ["art_sent_to_embroiderer"], :name => "index_jobs_on_art_sent_to_embroiderer"
  add_index "crm_jobs", ["artwork_burned"], :name => "index_jobs_on_artwork_burned"
  add_index "crm_jobs", ["custom_order_id"], :name => "index_jobs_on_custom_order_id"
  add_index "crm_jobs", ["digital_file_generated"], :name => "index_jobs_on_digital_file_generated"
  add_index "crm_jobs", ["digital_file_requested"], :name => "index_jobs_on_digital_file_requested"
  add_index "crm_jobs", ["inventoried"], :name => "index_jobs_on_inventoried"
  add_index "crm_jobs", ["ordered"], :name => "index_jobs_on_ordered"
  add_index "crm_jobs", ["print_date"], :name => "index_jobs_on_print_date"
  add_index "crm_jobs", ["printed"], :name => "index_jobs_on_printed"
  add_index "crm_jobs", ["received_from_embroiderer"], :name => "index_jobs_on_received_from_embroiderer"
  add_index "crm_jobs", ["rtp_art_approved"], :name => "index_jobs_on_rtp_art_approved"
  add_index "crm_jobs", ["scheduled"], :name => "index_jobs_on_scheduled"
  add_index "crm_jobs", ["sent_to_embroiderer"], :name => "index_jobs_on_sent_to_embroiderer"
  add_index "crm_jobs", ["type"], :name => "index_jobs_on_type"

  create_table "crm_line_items", :force => true do |t|
    t.integer  "order_id"
    t.integer  "inventory_id"
    t.string   "product"
    t.text     "description"
    t.string   "item_options"
    t.decimal  "unit_price",        :precision => 8, :scale => 2
    t.integer  "quantity"
    t.decimal  "total_price",       :precision => 8, :scale => 2
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "retail_product_id"
    t.boolean  "taxable"
    t.integer  "job_id"
    t.integer  "stock_item_id"
    t.boolean  "ordered",                                         :default => false
  end

  add_index "crm_line_items", ["inventory_id"], :name => "index_line_items_on_inventory_id"
  add_index "crm_line_items", ["job_id"], :name => "index_line_items_on_job_id"
  add_index "crm_line_items", ["order_id"], :name => "index_line_items_on_order_id"
  add_index "crm_line_items", ["product"], :name => "index_line_items_on_product"
  add_index "crm_line_items", ["quantity"], :name => "index_line_items_on_quantity"
  add_index "crm_line_items", ["total_price"], :name => "index_line_items_on_total_price"
  add_index "crm_line_items", ["unit_price"], :name => "index_line_items_on_unit_price"

  create_table "crm_name_and_numbers", :force => true do |t|
    t.integer  "order_id"
    t.integer  "job_id"
    t.integer  "inventory_id"
    t.string   "name"
    t.string   "number"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "crm_orders", :force => true do |t|
    t.integer  "customer_id"
    t.string   "delivery_first_name"
    t.string   "delivery_last_name"
    t.string   "delivery_address_1"
    t.string   "delivery_address_2"
    t.string   "delivery_city"
    t.string   "delivery_state"
    t.string   "delivery_zipcode"
    t.string   "delivery_country"
    t.integer  "administrator_id"
    t.string   "number"
    t.string   "type"
    t.decimal  "subtotal",                  :precision => 8, :scale => 2
    t.decimal  "total",                     :precision => 8, :scale => 2
    t.decimal  "tax",                       :precision => 8, :scale => 2
    t.decimal  "shipping",                  :precision => 8, :scale => 2
    t.decimal  "balance",                   :precision => 8, :scale => 2
    t.string   "status",                                                  :default => "Pending"
    t.string   "ip"
    t.text     "customer_comments"
    t.datetime "ship_date"
    t.string   "ship_method"
    t.text     "customer_description"
    t.text     "approximate_quantity"
    t.date     "delivery_deadline"
    t.boolean  "is_shipped",                                              :default => false
    t.date     "shipped_deadline"
    t.boolean  "is_ink_in_stock",                                         :default => false
    t.date     "ink_ordered_deadline"
    t.boolean  "are_garments_in_stock",                                   :default => false
    t.date     "garments_ordered_deadline"
    t.string   "order_source"
    t.integer  "bid_request_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.boolean  "is_tax_exempt",                                           :default => false
    t.string   "tax_id_number"
    t.boolean  "are_garments_ordered",                                    :default => false
    t.string   "title",                                                   :default => ""
    t.boolean  "redo",                                                    :default => false
    t.string   "whos_fault",                                              :default => ""
    t.string   "redo_reason",                                             :default => ""
    t.string   "delivery_phone_number"
    t.decimal  "discounts",                 :precision => 8, :scale => 2
    t.boolean  "limited_retail_run",                                      :default => false
    t.string   "limited_retail_run_title"
    t.string   "terms"
    t.string   "po"
    t.integer  "commission_salesperson_id"
    t.decimal  "commission_amount",         :precision => 8, :scale => 2, :default => 0.0
    t.boolean  "scheduled",                                               :default => false
    t.date     "scheduled_print_date"
    t.string   "delivery_company"
    t.string   "delivery_address_3"
  end

  add_index "crm_orders", ["are_garments_in_stock"], :name => "index_orders_on_are_garments_in_stock"
  add_index "crm_orders", ["balance"], :name => "index_orders_on_balance"
  add_index "crm_orders", ["bid_request_id"], :name => "index_orders_on_bid_request_id"
  add_index "crm_orders", ["customer_id"], :name => "index_orders_on_customer_id"
  add_index "crm_orders", ["delivery_address_1"], :name => "index_orders_on_delivery_address_1"
  add_index "crm_orders", ["delivery_address_2"], :name => "index_orders_on_delivery_address_2"
  add_index "crm_orders", ["delivery_city"], :name => "index_orders_on_delivery_city"
  add_index "crm_orders", ["delivery_country"], :name => "index_orders_on_delivery_country"
  add_index "crm_orders", ["delivery_deadline"], :name => "index_orders_on_delivery_deadline"
  add_index "crm_orders", ["delivery_first_name"], :name => "index_orders_on_delivery_first_name"
  add_index "crm_orders", ["delivery_last_name"], :name => "index_orders_on_delivery_last_name"
  add_index "crm_orders", ["delivery_state"], :name => "index_orders_on_delivery_state"
  add_index "crm_orders", ["delivery_zipcode"], :name => "index_orders_on_delivery_zipcode"
  add_index "crm_orders", ["garments_ordered_deadline"], :name => "index_orders_on_garments_ordered_deadline"
  add_index "crm_orders", ["ink_ordered_deadline"], :name => "index_orders_on_ink_ordered_deadline"
  add_index "crm_orders", ["is_ink_in_stock"], :name => "index_orders_on_is_ink_in_stock"
  add_index "crm_orders", ["is_shipped"], :name => "index_orders_on_is_shipped"
  add_index "crm_orders", ["is_tax_exempt"], :name => "index_orders_on_is_tax_exempt"
  add_index "crm_orders", ["number"], :name => "index_orders_on_number"
  add_index "crm_orders", ["order_source"], :name => "index_orders_on_order_source"
  add_index "crm_orders", ["ship_date"], :name => "index_orders_on_ship_date"
  add_index "crm_orders", ["ship_method"], :name => "index_orders_on_ship_method"
  add_index "crm_orders", ["shipped_deadline"], :name => "index_orders_on_shipped_deadline"
  add_index "crm_orders", ["shipping"], :name => "index_orders_on_shipping"
  add_index "crm_orders", ["status"], :name => "index_orders_on_status"
  add_index "crm_orders", ["subtotal"], :name => "index_orders_on_subtotal"
  add_index "crm_orders", ["tax"], :name => "index_orders_on_tax"
  add_index "crm_orders", ["total"], :name => "index_orders_on_total"

  create_table "crm_payments", :force => true do |t|
    t.string   "order_id"
    t.string   "user_id"
    t.string   "drivers_license_number"
    t.integer  "check_number"
    t.string   "credit_card_number"
    t.string   "credit_card_type"
    t.date     "credit_card_exp_date"
    t.string   "deposit_number"
    t.string   "first_name"
    t.string   "last_name"
    t.string   "address_1"
    t.string   "address_2"
    t.string   "city"
    t.string   "state"
    t.string   "zipcode"
    t.string   "country"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "payment_method"
    t.decimal  "amount",                 :precision => 8, :scale => 2
    t.string   "email"
    t.string   "paypal_transaction_id"
  end

  add_index "crm_payments", ["address_1"], :name => "index_payments_on_address_1"
  add_index "crm_payments", ["address_2"], :name => "index_payments_on_address_2"
  add_index "crm_payments", ["check_number"], :name => "index_payments_on_check_number"
  add_index "crm_payments", ["city"], :name => "index_payments_on_city"
  add_index "crm_payments", ["country"], :name => "index_payments_on_country"
  add_index "crm_payments", ["credit_card_type"], :name => "index_payments_on_credit_card_type"
  add_index "crm_payments", ["deposit_number"], :name => "index_payments_on_deposit_number"
  add_index "crm_payments", ["drivers_license_number"], :name => "index_payments_on_drivers_license_number"
  add_index "crm_payments", ["first_name"], :name => "index_payments_on_first_name"
  add_index "crm_payments", ["last_name"], :name => "index_payments_on_last_name"
  add_index "crm_payments", ["order_id"], :name => "index_payments_on_order_id"
  add_index "crm_payments", ["state"], :name => "index_payments_on_state"
  add_index "crm_payments", ["user_id"], :name => "index_payments_on_user_id"
  add_index "crm_payments", ["zipcode"], :name => "index_payments_on_zipcode"

  create_table "crm_platens", :force => true do |t|
    t.string  "size"
    t.integer "inventory_id"
    t.integer "print_method_id"
    t.string  "print_method_text"
  end

  add_index "crm_platens", ["inventory_id"], :name => "index_platens_on_inventory_id"
  add_index "crm_platens", ["print_method_id"], :name => "index_platens_on_print_method_id"
  add_index "crm_platens", ["print_method_text"], :name => "index_platens_on_print_method_text"

  create_table "crm_print_methods", :force => true do |t|
    t.string "print_method"
  end

  create_table "crm_proof_images", :force => true do |t|
    t.integer  "parent_id"
    t.string   "content_type"
    t.string   "filename"
    t.string   "thumbnail"
    t.integer  "size"
    t.integer  "width"
    t.integer  "height"
    t.integer  "custom_order_id"
    t.text     "description"
    t.string   "status",           :default => "Pending"
    t.string   "initials"
    t.text     "rejection_reason"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "job_id"
  end

  add_index "crm_proof_images", ["custom_order_id"], :name => "index_proof_images_on_custom_order_id"
  add_index "crm_proof_images", ["job_id"], :name => "index_proof_images_on_job_id"
  add_index "crm_proof_images", ["status"], :name => "index_proof_images_on_status"

  create_table "crm_queued_mails", :force => true do |t|
    t.text   "object"
    t.string "mailer"
  end

  create_table "crm_retail_categories", :force => true do |t|
    t.integer  "parent_category_id", :default => 0
    t.string   "title"
    t.string   "image"
    t.integer  "administrator_id",   :default => 1
    t.integer  "parent_id"
    t.string   "content_type"
    t.string   "filename"
    t.string   "thumbnail"
    t.integer  "size"
    t.integer  "width"
    t.integer  "height"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.boolean  "active",             :default => true
    t.string   "redirect_url"
  end

  add_index "crm_retail_categories", ["administrator_id"], :name => "index_retail_categories_on_administrator_id"
  add_index "crm_retail_categories", ["parent_category_id"], :name => "index_retail_categories_on_parent_category_id"

  create_table "crm_retail_categories_retail_products", :id => false, :force => true do |t|
    t.integer "retail_product_id",  :null => false
    t.integer "retail_category_id", :null => false
  end

  add_index "crm_retail_categories_retail_products", ["retail_category_id"], :name => "index_retail_categories_retail_products_on_retail_category_id"
  add_index "crm_retail_categories_retail_products", ["retail_product_id"], :name => "index_retail_categories_retail_products_on_retail_product_id"

  create_table "crm_retail_colors", :force => true do |t|
    t.string "color"
    t.string "american_apparel_color"
    t.string "gildan_color"
    t.string "port_and_co_color"
    t.string "anvil_color"
    t.string "hanes_color"
  end

  create_table "crm_retail_inventories_sales", :force => true do |t|
    t.string   "added_by"
    t.integer  "inventory_id"
    t.integer  "quantity"
    t.integer  "order_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "crm_retail_inventories_sales", ["inventory_id"], :name => "index_retail_inventories_sales_on_inventory_id"

  create_table "crm_retail_misprints", :force => true do |t|
    t.boolean  "used",              :default => false
    t.string   "reason"
    t.integer  "retail_product_id"
    t.integer  "inventory_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "crm_retail_misprints", ["inventory_id"], :name => "index_retail_misprints_on_inventory_id"
  add_index "crm_retail_misprints", ["retail_product_id"], :name => "index_retail_misprints_on_retail_product_id"
  add_index "crm_retail_misprints", ["used"], :name => "index_retail_misprints_on_used"

  create_table "crm_retail_product_colors", :force => true do |t|
    t.integer  "retail_product_id"
    t.integer  "retail_color_id"
    t.string   "image_type"
    t.integer  "parent_id"
    t.string   "content_type"
    t.string   "filename"
    t.string   "thumbnail"
    t.integer  "size"
    t.integer  "width"
    t.integer  "height"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "print_method_id"
    t.string   "product_code"
  end

  add_index "crm_retail_product_colors", ["print_method_id"], :name => "index_retail_product_colors_on_print_method_id"
  add_index "crm_retail_product_colors", ["retail_color_id"], :name => "index_retail_product_colors_on_retail_color_id"
  add_index "crm_retail_product_colors", ["retail_product_id"], :name => "index_retail_product_colors_on_retail_product_id"

  create_table "crm_retail_product_images", :force => true do |t|
    t.integer  "retail_product_id"
    t.string   "image_type"
    t.integer  "parent_id"
    t.string   "content_type"
    t.string   "filename"
    t.string   "thumbnail"
    t.integer  "size"
    t.integer  "width"
    t.integer  "height"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "crm_retail_product_options", :force => true do |t|
    t.integer "retail_product_id"
    t.string  "option_prompt"
    t.string  "option_input_type"
    t.decimal "price",             :precision => 8, :scale => 2
  end

  create_table "crm_retail_products", :force => true do |t|
    t.string   "title"
    t.string   "code"
    t.text     "description"
    t.decimal  "price",                          :precision => 8,  :scale => 2
    t.string   "author"
    t.string   "product_type"
    t.boolean  "taxable",                                                       :default => true
    t.integer  "brand_id"
    t.string   "catalog_number"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.boolean  "active",                                                        :default => true
    t.boolean  "popular",                                                       :default => true
    t.text     "meta_description"
    t.text     "meta_keywords"
    t.boolean  "on_store_homepage",                                             :default => true
    t.integer  "homepage_order",                                                :default => 0
    t.text     "print_notes"
    t.boolean  "limited_run",                                                   :default => false
    t.string   "limited_run_title"
    t.decimal  "american_apparel_upgrade_price", :precision => 8,  :scale => 2, :default => 4.0
    t.boolean  "require_tracking",                                              :default => false
    t.decimal  "third_party_commission",         :precision => 10, :scale => 2, :default => 0.0
    t.integer  "print_method_id"
    t.string   "redirect_url"
  end

  add_index "crm_retail_products", ["active"], :name => "index_retail_products_on_active"
  add_index "crm_retail_products", ["popular"], :name => "index_retail_products_on_popular"
  add_index "crm_retail_products", ["print_method_id"], :name => "index_retail_products_on_print_method_id"
  add_index "crm_retail_products", ["taxable"], :name => "index_retail_products_on_taxable"

  create_table "crm_retail_products_similar_retail_products", :id => false, :force => true do |t|
    t.integer "retail_product_id"
    t.integer "similar_retail_product_id"
  end

  add_index "crm_retail_products_similar_retail_products", ["retail_product_id"], :name => "retail_product_id"
  add_index "crm_retail_products_similar_retail_products", ["similar_retail_product_id"], :name => "similar_retail_product_id"

  create_table "crm_screens", :force => true do |t|
    t.string  "label"
    t.integer "job_id"
    t.string  "description"
    t.string  "print_location"
    t.string  "film_type"
    t.string  "frame_type"
    t.string  "screen_mesh"
    t.string  "emulsion_type"
    t.integer "quantity",       :default => 1
    t.string  "notes"
  end

  add_index "crm_screens", ["emulsion_type"], :name => "index_screens_on_emulsion_type"
  add_index "crm_screens", ["film_type"], :name => "index_screens_on_film_type"
  add_index "crm_screens", ["frame_type"], :name => "index_screens_on_frame_type"
  add_index "crm_screens", ["job_id"], :name => "index_screens_on_job_id"
  add_index "crm_screens", ["label"], :name => "index_screens_on_label"
  add_index "crm_screens", ["print_location"], :name => "index_screens_on_print_location"
  add_index "crm_screens", ["quantity"], :name => "index_screens_on_quantity"
  add_index "crm_screens", ["screen_mesh"], :name => "index_screens_on_screen_mesh"

  create_table "crm_sessions", :force => true do |t|
    t.string   "session_id",                     :null => false
    t.text     "data",       :limit => 16777215, :null => false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "crm_sessions", ["session_id"], :name => "index_sessions_on_session_id"
  add_index "crm_sessions", ["updated_at"], :name => "index_sessions_on_updated_at"

  create_table "crm_shipments", :force => true do |t|
    t.integer  "order_id"
    t.string   "shipping_method"
    t.string   "tracking_number"
    t.string   "description"
    t.decimal  "cost",            :precision => 8, :scale => 2
    t.boolean  "deleted",                                       :default => false
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "shipped_by"
  end

  add_index "crm_shipments", ["cost"], :name => "index_shipments_on_cost"
  add_index "crm_shipments", ["deleted"], :name => "index_shipments_on_deleted"
  add_index "crm_shipments", ["order_id"], :name => "index_shipments_on_order_id"
  add_index "crm_shipments", ["shipping_method"], :name => "index_shipments_on_shipping_method"
  add_index "crm_shipments", ["tracking_number"], :name => "index_shipments_on_tracking_number"

  create_table "crm_sites", :force => true do |t|
    t.string   "domain"
    t.string   "page_title"
    t.string   "company_name"
    t.text     "keywords"
    t.text     "description"
    t.string   "stylesheet"
    t.string   "phone_number"
    t.string   "location"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "crm_stock_items", :force => true do |t|
    t.string   "name"
    t.integer  "retail_product_id"
    t.string   "size"
    t.string   "color"
    t.integer  "stock_level"
    t.string   "product_type"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "lbs",               :default => 0
    t.integer  "oz",                :default => 0
    t.integer  "restock_time",      :default => 0
  end

  add_index "crm_stock_items", ["color"], :name => "index_stock_items_on_color"
  add_index "crm_stock_items", ["retail_product_id"], :name => "index_stock_items_on_retail_product_id"
  add_index "crm_stock_items", ["size"], :name => "index_stock_items_on_size"
  add_index "crm_stock_items", ["stock_level"], :name => "index_stock_items_on_stock_level"

  create_table "crm_supplier_locations", :force => true do |t|
    t.integer "supplier_id"
    t.string  "location"
    t.integer "transit_time"
    t.time    "cutoff_time",  :default => '2000-01-01 00:00:00'
    t.boolean "default",      :default => false
    t.boolean "mill_direct",  :default => false
  end

  create_table "crm_suppliers", :force => true do |t|
    t.string "name"
    t.string "supplier_type"
    t.string "website"
    t.string "shipment_method"
  end

  create_table "crm_taggings", :force => true do |t|
    t.integer  "tag_id"
    t.integer  "taggable_id"
    t.string   "taggable_type"
    t.datetime "created_at"
  end

  add_index "crm_taggings", ["tag_id"], :name => "index_taggings_on_tag_id"
  add_index "crm_taggings", ["taggable_id", "taggable_type"], :name => "index_taggings_on_taggable_id_and_taggable_type"

  create_table "crm_tags", :force => true do |t|
    t.string "name"
  end

  create_table "crm_users", :force => true do |t|
    t.string   "email"
    t.string   "type"
    t.boolean  "account_enabled",                         :default => false
    t.string   "first_name"
    t.string   "last_name"
    t.string   "address_1"
    t.string   "address_2"
    t.string   "city"
    t.string   "state"
    t.string   "zipcode"
    t.string   "country"
    t.string   "phone_number"
    t.string   "crypted_password",          :limit => 40
    t.string   "salt",                      :limit => 40
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "remember_token"
    t.datetime "remember_token_expires_at"
    t.boolean  "salesperson",                             :default => false
    t.string   "company"
    t.string   "address_3"
  end

  add_index "crm_users", ["account_enabled"], :name => "index_users_on_account_enabled"
  add_index "crm_users", ["city"], :name => "index_users_on_city"
  add_index "crm_users", ["email"], :name => "index_users_on_email"
  add_index "crm_users", ["first_name"], :name => "index_users_on_first_name"
  add_index "crm_users", ["last_name"], :name => "index_users_on_last_name"
  add_index "crm_users", ["type"], :name => "index_users_on_type"
end
