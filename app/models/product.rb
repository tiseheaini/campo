class Product < ActiveRecord::Base
  include Trashable

  belongs_to :user

  has_many :item_attr

  validates :name, presence: true
end
