# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# Note that this schema.rb definition is the authoritative source for your
# database schema. If you need to create the application database on another
# system, you should be using db:schema:load, not running all the migrations
# from scratch. The latter is a flawed and unsustainable approach (the more migrations
# you'll amass, the slower it'll run and the greater likelihood for issues).
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema.define(version: 20171121054433) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "follows", force: :cascade do |t|
    t.integer  "following_id", null: false
    t.integer  "follower_id",  null: false
    t.datetime "created_at",   null: false
    t.datetime "updated_at",   null: false
    t.index ["follower_id"], name: "index_follows_on_follower_id", using: :btree
    t.index ["following_id", "follower_id"], name: "index_follows_on_following_id_and_follower_id", unique: true, using: :btree
    t.index ["following_id"], name: "index_follows_on_following_id", using: :btree
  end

  create_table "invitations", force: :cascade do |t|
    t.integer  "sender_id"
    t.string   "recipient_email"
    t.boolean  "viewed",          default: false
    t.boolean  "accepted",        default: false
    t.datetime "created_at",                      null: false
    t.datetime "updated_at",                      null: false
    t.index ["recipient_email"], name: "index_invitations_on_recipient_email", using: :btree
    t.index ["sender_id", "recipient_email"], name: "index_invitations_on_sender_id_and_recipient_email", unique: true, using: :btree
    t.index ["sender_id"], name: "index_invitations_on_sender_id", using: :btree
  end

  create_table "links", force: :cascade do |t|
    t.integer  "user_id"
    t.string   "url",                          null: false
    t.integer  "seen_by",      default: [],                 array: true
    t.datetime "created_at",                   null: false
    t.datetime "updated_at",                   null: false
    t.boolean  "current",      default: false
    t.integer  "upvote_count", default: 0
    t.boolean  "hidden",       default: false
    t.index ["user_id"], name: "index_links_on_user_id", using: :btree
  end

  create_table "users", force: :cascade do |t|
    t.string   "email",                  default: "", null: false
    t.string   "encrypted_password",     default: "", null: false
    t.string   "username",               default: "", null: false
    t.string   "avatar"
    t.string   "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.integer  "sign_in_count",          default: 0
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.string   "current_sign_in_ip"
    t.string   "last_sign_in_ip"
    t.datetime "created_at",                          null: false
    t.datetime "updated_at",                          null: false
    t.string   "follow_code"
    t.string   "default_avatar_color"
    t.index ["email"], name: "index_users_on_email", unique: true, using: :btree
    t.index ["follow_code"], name: "index_users_on_follow_code", unique: true, using: :btree
    t.index ["username"], name: "index_users_on_username", unique: true, using: :btree
  end

  create_table "votes", force: :cascade do |t|
    t.string   "votable_type"
    t.integer  "votable_id"
    t.string   "voter_type"
    t.integer  "voter_id"
    t.boolean  "vote_flag"
    t.string   "vote_scope"
    t.integer  "vote_weight"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.index ["votable_id", "votable_type", "vote_scope"], name: "index_votes_on_votable_id_and_votable_type_and_vote_scope", using: :btree
    t.index ["voter_id", "voter_type", "vote_scope"], name: "index_votes_on_voter_id_and_voter_type_and_vote_scope", using: :btree
  end

end
