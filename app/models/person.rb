class Person < ApplicationRecord
  has_many :person_item_storages

  enum sex: { unknown: 0, men: 1, women: 2 }
end
