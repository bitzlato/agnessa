class LegacyVerificationsController < ApplicationController
  def index
    verifications = Verification.
      all.
      order('created_at DESC').
      map do |v|
      {
        id: v.legacy_external_id,
        status: v.status.to_s == 'confirmed' ? true : false,
        comment: v.external_json['comment'],
        time: v.legacy_created || (v.created_at.to_i * 1000)

      }
    end

    render json: verifications
  end
end
