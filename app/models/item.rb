class Item < ApplicationRecord
  ENUM_ITEM_TYPE = { unknown: 0, weapon: 1, medicine: 2, tool: 3 }.freeze

  has_one :person_item_storage

  enum item_type: ENUM_ITEM_TYPE
end
