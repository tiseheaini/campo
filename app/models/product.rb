class Product < ActiveRecord::Base
  include Trashable

  belongs_to :user

  has_many :item_attr

  validates :name, presence: true

  def update_attr(exist, modify)
    # 删除了部分商品属性
    (exist - modify).each do |attr|
      ItemAttr.where(id: attr).update_all(trashed: true)
    end

    # 添加了部分商品属性
    (modify - exist).each do |attr|
      ItemAttr.where(id: attr).update_all(product_id: self.id)
    end
  end
end
