class User < ActiveRecord::Base
  # include HTTP request helpers
  include Networkable

  belongs_to :publisher
  has_and_belongs_to_many :reports

  before_save :ensure_authentication_token
  after_create :set_first_user

  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable,
         :omniauthable, :omniauth_providers => [:persona, :cas]

  # Setup accessible (or protected) attributes for your model
  attr_accessible :username, :email, :password, :password_confirmation, :remember_me, :provider, :uid, :name, :role, :authentication_token, :publisher_id

  validates :username, :presence => true, :uniqueness => true
  validates :name, :presence => true
  validates :email, :uniqueness => true, :allow_blank => true

  scope :query, lambda { |query| where("name like ? OR username like ? OR authentication_token like ?", "%#{query}%", "%#{query}%", "%#{query}%") }
  scope :ordered, order("sign_in_count DESC, updated_at DESC")

  def self.find_for_cas_oauth(auth, signed_in_resource=nil)
    user = User.where(:provider => auth.provider, :uid => auth.uid).first
    unless user
      unless Rails.env.test?
        # We obtain the email address from a second call to the CAS server
        url = "#{CONFIG[:cas_url]}/cas/email?guid=#{auth.uid}"
        result = User.new.get_result(url, content_type: 'html')
        email = result.blank? ? "" : result
      else
        email = auth.info.email
      end
      name = email.present? ? email : auth.uid
      username = email.present? ? email : auth.uid

      user = User.create!(:username => username,
                          :name => name,
                          :authentication_token => auth.token,
                          :provider => auth.provider,
                          :uid => auth.uid,
                          :email => email)
    end

    user
  end

  def self.find_for_persona_oauth(auth, signed_in_resource=nil)
    user = User.where(:provider => auth.provider, :uid => auth.uid).first
    unless user
      user = User.create!(:username => auth.info.email,
                          :name => auth.info.name,
                          :authentication_token => auth.token,
                          :provider => auth.provider,
                          :uid => auth.uid,
                          :email => auth.info.email)
    end

    user
  end

  # Virtual attribute for authenticating by either username or email
  # This is in addition to a real persisted field like 'username'
  attr_accessor :login

  attr_accessible :login

  def self.find_for_database_authentication(warden_conditions)
    conditions = warden_conditions.dup
    login = conditions.delete(:login)
    where(conditions).where(["lower(username) = :value OR lower(email) = :value", { :value => login.strip.downcase }]).first
  end

  def self.per_page
    15
  end

  # Helper method to check for admin user
  def is_admin?
    role == "admin"
  end

  # Helper method to check for admin or staff user
  def is_admin_or_staff?
    ["admin", "staff"].include?(role)
  end

  # Use different cache key for admin or staff user
  def cache_key
    is_admin_or_staff? ? "1" : "2"
  end

  def api_key
    authentication_token
  end

  def email_with_name
    if email && name != email
      "#{name} <#{email}>"
    else
      email
    end
  end

  protected

  def set_first_user
    # The first user we create has an admin role and uses the configuration API key
    # unless it is in the test environment
    if User.count == 1 && !Rails.env.test?
      update_attributes(role: "admin", authentication_token: CONFIG[:api_key])
    end
  end

  # Don't require email or password, as we also use OAuth
  def email_required?
    false
  end

  def password_required?
    false
  end

  # Attempt to find a user by it's email. If a record is found, send new
  # password instructions to it. If not user is found, returns a new user
  # with an email not found error.
  def self.send_reset_password_instructions(attributes={})
    recoverable = find_recoverable_or_initialize_with_errors(reset_password_keys, attributes, :not_found)
    recoverable.send_reset_password_instructions if recoverable.persisted?
    recoverable
  end

  def self.find_recoverable_or_initialize_with_errors(required_attributes, attributes, error=:invalid)
    (case_insensitive_keys || []).each { |k| attributes[k].try(:downcase!) }

    attributes = attributes.slice(*required_attributes)
    attributes.delete_if { |key, value| value.blank? }

    if attributes.size == required_attributes.size
      record = where(attributes).first
    end

    unless record
      record = new

      required_attributes.each do |key|
        value = attributes[key]
        record.send("#{key}=", value)
        record.errors.add(key, value.present? ? error : :blank)
      end
    end
    record
  end

  def ensure_authentication_token
    if authentication_token.blank?
      self.authentication_token = generate_authentication_token
    end
  end

  private

  def generate_authentication_token
    loop do
      token = Devise.friendly_token
      break token unless User.where(authentication_token: token).first
    end
  end
end
