class Step1Form
  include ActiveFormModel

  # # list all the permitted params
  # permit :first_name, :email, :password
  #
  # # add validation if necessary
  # # they will be merged with base class' validation
  # validates :password, presence: true
  #
  # # optional data normalization
  # def email=(email)
  #   if email.present?
  #     write_attribute(:email, email.downcase)
  #   else
  #     super
  #   end
  # end
end