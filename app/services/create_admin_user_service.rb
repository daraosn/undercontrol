class CreateAdminUserService
  def self.make
    user = User.find_or_create_by!(email: Rails.application.secrets.admin_email) do |user|
      user.name = "Undercontrol.io"
      user.username = "undercontrol"
      user.email = "admin@undercontrol.io"
      user.password = Rails.application.secrets.admin_password
      user.password_confirmation = Rails.application.secrets.admin_password
    end
    user.confirm!
  end
end