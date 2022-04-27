module Archivable
  extend ActiveSupport::Concern

  included do
    scope :archive, -> { where 'archived_at is not null' }
    scope :alive,   -> { where archived_at: nil }
  end

  class_methods do
    def archive_all!(at: Time.zone.now)
      update_all archived_at: at
    end

    def restore_all!
      update_all archived_at: nil
    end
  end

  def active?
    return false if respond_to?(:is_active) && !is_active
    alive?
  end

  def archive
    self.archived_at ||= Time.zone.now
  end

  def archive!
    update_column :archived_at, Time.zone.now
  end

  def restore
    self.archived_at = nil
  end

  def restore!
    update_column :archived_at, nil
  end

  def archived?
    archived_at.present?
  end

  def alive?
    ! archived?
  end

  def alive_presence
    alive? ? self : nil
  end
end
