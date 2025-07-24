-- Create cached_assets table
CREATE TABLE IF NOT EXISTS cached_assets (
  id TEXT PRIMARY KEY,
  url TEXT NOT NULL,
  type TEXT NOT NULL,
  local_path TEXT,
  last_updated TEXT NOT NULL,
  metadata TEXT
);

-- Create place_assets junction table
CREATE TABLE IF NOT EXISTS place_assets (
  place_id TEXT NOT NULL,
  asset_id TEXT NOT NULL,
  last_updated TEXT NOT NULL,
  PRIMARY KEY (place_id, asset_id),
  FOREIGN KEY (asset_id) REFERENCES cached_assets (id) ON DELETE CASCADE
);

-- Create index for faster lookups
CREATE INDEX IF NOT EXISTS idx_place_assets_place_id ON place_assets(place_id);
CREATE INDEX IF NOT EXISTS idx_place_assets_asset_id ON place_assets(asset_id);
