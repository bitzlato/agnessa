class Admin::ApplicantsController < Admin::ResourcesController
  def show
    versions = record.versions.with_blocked.includes(:subject)
    render locals: { record: record, versions: versions }
  end

  def block
    record.update!(blocked: true)
    redirect_back fallback_location: admin_root_path
  end

  def unblock
    record.update!(blocked: false)
    redirect_back fallback_location: admin_root_path
  end
end
