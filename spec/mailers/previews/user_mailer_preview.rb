# Preview all emails at http://localhost:3000/rails/mailers/user_mailer

class UserMailerPreview < ActionMailer::Preview
  def confirm_account
    user = FactoryGirl.build(:user)
    UserMailer.confirm_account(user.email, user.password)
  end
end
