class Admin::ApplicantsController < Admin::ResourcesController
  def block
    record.block!(current_member)
    redirect_back fallback_location: admin_root_path
  end

  def unblock
    record.unblock!(current_member)
    redirect_back fallback_location: admin_root_path
  end
end
