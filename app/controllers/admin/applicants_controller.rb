class Admin::ApplicantsController < Admin::ResourcesController

  def show
    render locals: { applicant: applicant }
  end

  private

  def applicant
    @applicant ||= Applicant.find(params[:id])
  end
end
