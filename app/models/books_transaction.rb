class BooksTransaction < ApplicationRecord
  belongs_to :user
  belongs_to :book
  has_one :parent, class_name: 'BooksTransaction', foreign_key: :parent_id, required: false
  enum status: {
    no_returned: 0,
    returned: 1
  }
  enum option: {
    out: 1,
    back: 2
  }
  include AASM
  aasm column: :status, whiny_transitions: true, enum: true do
    state :no_returned, initial: true
    state :returned

    event :return do
      transitions from: :no_returned, to: :returned
    end
  end
end
