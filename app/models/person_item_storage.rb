class PersonItemStorage < ApplicationRecord
  acts_as_paranoid

  belongs_to :item
  belongs_to :person
end
