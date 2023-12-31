class TileTracepoints < ActiveRecord::Migration[4.2]
  class Tracepoint < ApplicationRecord
    self.table_name = "gps_points"
  end

  def self.up
    add_column "gps_points", "tile", :bigint
    add_index "gps_points", ["tile"], :name => "points_tile_idx"
    remove_index "gps_points", :name => "points_idx"

    Tracepoint.all.each do |tp|
      tp.latitude = tp.latitude * 10
      tp.longitude = tp.longitude * 10
      tp.save!
    end
  end

  def self.down
    Tracepoint.update_all("latitude = latitude / 10, longitude = longitude / 10")

    add_index "gps_points", %w[latitude longitude], :name => "points_idx"
    remove_index "gps_points", :name => "points_tile_idx"
    remove_column "gps_points", "tile"
  end
end
