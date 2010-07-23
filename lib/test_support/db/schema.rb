require 'sniff/database'

Sniff::Database.define_schema do
  create_table "bus_trip_records", :force => true do |t|
    t.string   "name"
    t.integer  "profile_id"
    t.date     "date"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.float    "duration"
    t.float    "distance_estimate"
    t.integer  "bus_class_id"
  end
end
