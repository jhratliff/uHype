class SnapshotUnlike < ActiveRecord::Base
  belongs_to :user
  belongs_to :snapshot
end
