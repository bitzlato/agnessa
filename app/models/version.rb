class Version < ApplicationRecord
  belongs_to :subject, polymorphic: true
  belongs_to :member

  scope :with_blocked, ->(){where("subject_changes ? 'blocked'")}

  validates :subject, :changes, :member_id, presence: true
end
