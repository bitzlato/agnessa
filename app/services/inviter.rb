class Inviter
  attr_reader :account, :email, :inviter

  def initialize(account:, email:, inviter:)
    @account = account
    @email   = email
    @inviter = inviter
  end

  def perform!
    if user.present?
      add_membership
      :membership_created
    else
      invite = create_invite
      UserMailer
        .invite(invite.id)
        .deliver!

      :invited
    end
  end

  private

  def user
    @user ||= User.find_by(email: email.to_s.downcase)
  end

  def create_invite
    account.invites
           .create_with!(inviter: inviter)
           .find_or_create_by!(email: email)
  end

  def add_membership
    account.with_lock do
      account.members.find_or_create_by(user: user)
    end
  end
end
