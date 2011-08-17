# Seller store.
# This table conatints quotes sold to virtual seller, but stored at seller's
#
# Эта таблица содержит варианты которые были проданы виртуальному продавцу но оставлены на хранения у продовца
class SellerStore < ActiveRecord::Base
  belongs_to :seller, :class_name => "User" # realy seller
  belongs_to :dealer, :class_name => "User" # virtual seller

  belongs_to :variant                         # quote realy seller
  belongs_to :quote, :class_name => "Variant" # quote virtual seller
  belongs_to :order

end
