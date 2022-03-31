class Version < ApplicationRecord
  belongs_to :subject, polymorphic: true
  belongs_to :member, optional: true

  scope :with_blocked, ->(){ where("subject_changes ? 'blocked'") }
  scope :ordered, ->(){ order(:created_at) }

  validates :subject, :changes, presence: true
end
