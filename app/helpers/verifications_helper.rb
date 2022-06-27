module VerificationsHelper
  def statused_verifications
    status_from_query = request.query_parameters.fetch(:q, {}).fetch(:status_eq, nil)
    scope = current_account.verifications

    status_from_query.blank? ? scope : scope.by_status(status_from_query)
  end

  def tmp_full_path(relative_path)
    "/#{CarrierWave::Uploader::Base.cache_dir}/#{relative_path}"
  end
end
