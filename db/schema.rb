# encoding: UTF-8
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
# It's strongly recommended to check this file into your version control system.

ActiveRecord::Schema.define(:version => 20120618122254) do

  create_table "hdfs_paths", :force => true do |t|
    t.string   "path"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "merge_jobs", :force => true do |t|
    t.string   "hdfs_src"
    t.string   "dest_server"
    t.string   "dest_path"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "copy_dst"
    t.string   "solr_version"
    t.string   "solr_lib_path"
    t.string   "job_id"
    t.string   "solr_schema"
  end

  create_table "servers", :force => true do |t|
    t.string   "name"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "solr_servers", :force => true do |t|
    t.string   "name"
    t.string   "port"
    t.string   "version"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "server_id"
  end

end
