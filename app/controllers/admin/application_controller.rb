class Admin::ApplicationController < ApplicationController
  include UserAuthSupport
  include PaginationSupport
  before_action :authorize_member

  layout 'fluid'

  helper_method :current_account
  helper_method :current_member
  attr_accessor :current_member

  before_action do
    # Чтобы на ноутбуках dashbard не был кривым
    @container = :fluid
  end

  def current_account
    RequestStore.store[:current_account]
  end

  private

  def current_member
    @current_member ||= current_account.members.find_by(user: current_user)
  end

  def authorize_member
    raise HumanizedError, :unauthorized_member unless current_member.present?
    raise HumanizedError, :archived_member if current_member.archived?
  end
end
