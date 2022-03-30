class Admin::ApplicantsController < Admin::ResourcesController
  def block
    record.update!(blocked: true)
    redirect_back fallback_location: admin_root_path
  end

  def unblock
    record.update!(blocked: false)
    redirect_back fallback_location: admin_root_path
  end
end
