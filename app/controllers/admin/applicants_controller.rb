class Admin::ApplicantsController < Admin::ResourcesController
  def show
    applicant_versions = record.versions.with_blocked.ordered
    verifications_versions = record.verifications_versions.ordered
    render locals: { record: record, applicant_versions: applicant_versions, verifications_versions: verifications_versions }
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
