class Vote < ApplicationRecord
  belongs_to :user
  belongs_to :votable, polymorphic: true

  validates :state, presence: true, inclusion: { in: %w[good bad] }
  validates :user, uniqueness: { scope: %i[votable_type votable_id] }

  enum state: { good: 1, bad: -1 }
end
