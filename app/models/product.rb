class Product < ActiveRecord::Base
  include Trashable

  belongs_to :user

  validates :name, :price, presence: true
  validates :price, numericality: true
end
