class Admin::ApplicationController < ApplicationController
  include UserAuthSupport
  include PaginationSupport
  before_action :authorize_member
  before_action :authorize_admin

  layout 'fluid'

  helper_method :current_account
  helper_method :current_member
  helper_method :is_admin?
  helper_method :is_operator?
  attr_accessor :current_member

  before_action do
    # Чтобы на ноутбуках dashbard не был кривым
    @container = :fluid
  end

  def current_account
    RequestStore.store[:current_account]
  end

  def is_admin?
    current_member.admin?
  end

  def is_operator?
    current_member.operator?
  end

  private

  def current_member
    @current_member ||= current_account.members.find_by(user: current_user)
  end

  def authorize_admin
    raise HumanizedError, :authorize_admin unless current_member.admin?
  end

  def authorize_member
    raise HumanizedError, :unauthorized_member unless current_member.present?
    raise HumanizedError, :archived_member if current_member.archived?
  end
end
