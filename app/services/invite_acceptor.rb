class InviteAcceptor
  attr_reader :invite, :user

  def initialize(invite, user = nil)
    @invite = invite
    @user = user || create_user
  end

  def accept!
    invite.with_lock do
      invite.account.members.create(user: user, inviter: invite.inviter)
      invite.delete
    end
    user
  end

  private

  def create_user
    User.create!({
      email: invite.email,
      first_name: invite.email.split('@').first
    })
  end
end
