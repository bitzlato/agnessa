module Versionable
  extend ActiveSupport::Concern

  included do
    after_commit :save_current_version
    has_many :versions, as: :subject, dependent: :delete_all

    private

    def save_current_version
      current_member = RequestStore.store[:current_member]
      versions.create!({
        subject_changes: previous_changes,
        state: attributes,
        member: current_member
      })
    end
  end
end