class User < ActiveRecord::Base
  has_many :things

  belongs_to :plan
  validates_associated :plan

  EMAIL_REGEX = /\b[A-Z0-9._%a-z\-]+@(?:[A-Z0-9a-z\-]+\.)+[A-Za-z]{2,4}\z/
  validates :email, presence: true, uniqueness: true, format: EMAIL_REGEX
  validates :name, presence: true
  validates :username, presence: true, uniqueness: true
  validates :password, confirmation: true
  validates_length_of :password, in: 8..255, on: [:create, :update]

  # Include default devise modules. Others available are:
  # :omniauthable
  devise :database_authenticatable, :registerable, :recoverable, :rememberable, :trackable, :confirmable, :lockable, :timeoutable

  # enum role: [:user, :admin, :silver, :gold, :platinum]
  # after_initialize :set_default_role, :if => :new_record?
  # after_initialize :set_default_plan, :if => :new_record?
  # after_create :sign_up_for_mailing_list

  # def set_default_role
  #   self.role ||= :user
  # end

  # def set_default_plan
  #   self.plan ||= Plan.last
  # end

  # def sign_up_for_mailing_list
  #   MailingListSignupJob.perform_later(self)
  # end
  #
  # def subscribe
  #   mailchimp = Gibbon::Request.new(api_key: Rails.application.secrets.mailchimp_api_key)
  #   list_id = Rails.application.secrets.mailchimp_list_id
  #   result = mailchimp.lists(list_id).members.create(
  #     body: {
  #       email_address: self.email,
  #       status: 'subscribed'
  #   })
  #   Rails.logger.info("Subscribed #{self.email} to MailChimp") if result
  # end

end
