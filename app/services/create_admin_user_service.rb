class CreateAdminUserService
  def self.make
    user = User.create!(
      email: Rails.application.secrets.admin_email,
      name: Rails.application.secrets.admin_name,
      username: Rails.application.secrets.admin_username,
      password: Rails.application.secrets.admin_password,
      password_confirmation: Rails.application.secrets.admin_password
    )
    user.confirm!
    user
  end
end