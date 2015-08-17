class ItemAttr < ActiveRecord::Base
  belongs_to :product

  default_scope { where(trashed: false) }
end
