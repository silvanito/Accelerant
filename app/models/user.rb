require 'digest/sha1'

class User < ActiveRecord::Base
  include Authentication
  include Authentication::ByPassword
  include Authentication::ByCookieToken
  #relatioship
  has_many :comments
  has_many :replies
  has_many :heatmaps
  has_many :report_comments
  has_many  :module_responses
  has_many :themes, :foreign_key => :owner
  belongs_to :user_assignments

  #scopes
  named_scope :is_moderator, :conditions => {:moderator => true}
  named_scope :is_admin, :conditions => {:admin => true}
  named_scope :is_participant, :conditions => {:participant => true}

  has_attached_file :avatar,
  :whiny => false, 
  :whiny_thumbnails => false,
  :styles => { :large => "300x300>",:medium => "100x100>", :thumb => "80x80>", :small => "50x50>", :smaller => "30x30>", :tiny => "20x20>" },
  :storage => :s3,
  :bucket => 'blognog1',
  :s3_credentials => { 
      :access_key_id => "AKIAJPBL7M7Q6JJOT24A", 
      :secret_access_key => "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"
  },
  :path =>   "avatars/:id/:style/:filename"

  validates_presence_of     :login
  validates_length_of       :login,    :within => 3..40
  validates_uniqueness_of   :login
  validates_format_of       :login,    :with => Authentication.login_regex, :message => Authentication.bad_login_message

  validates_format_of       :name,     :with => Authentication.name_regex,  :message => Authentication.bad_name_message, :allow_nil => true
  validates_length_of       :name,     :maximum => 100

  validates_presence_of     :email
  validates_length_of       :email,    :within => 6..100 #r@a.wk
  validates_uniqueness_of   :email
  validates_format_of       :email,    :with => Authentication.email_regex, :message => Authentication.bad_email_message


  

  # HACK HACK HACK -- how to do attr_accessible from here?
  # prevents a user from submitting a crafted form that bypasses activation
  # anything else you want your user to change should be added here.
  attr_accessible :login, :email, :name, :password, :password_confirmation,
  :admin, :client, :moderator, :participant, :avatar, :avatar_file_name, :avatar_content_type, :avatar_file_size, :avatar_updated_at,
  :field_1,
  :field_2,
  :field_3,
  :field_4,
  :field_5,
  :field_6,
  :field_7,
  :field_8,
  :field_9,
  :field_10



  # Authenticates a user by their login name and unencrypted password.  Returns the user or nil.
  #
  # uff.  this is really an authorization, not authentication routine.  
  # We really need a Dispatch Chain here or something.
  # This will also let us return a human error message.
  #
  def self.authenticate(login, password)
    return nil if login.blank? || password.blank?
    u = find_by_login(login.downcase) # need to get the salt
    u && u.authenticated?(password) ? u : nil
  end

  def login=(value)
    write_attribute :login, (value ? value.downcase : nil)
  end

  def email=(value)
    write_attribute :email, (value ? value.downcase : nil)
  end

  def rol
    if self.admin
      return "admin"
    elsif self.moderator
      return "moderator"
    elsif self.client
      return "client"
    else
      return "participant"
    end
  end

  def upadate_attributes_as_user(values, user)
    values.each do |attribute, value|
      # Update the attribute if the user is allowed to
      self.send("#{attribute}=", value) if  !user.can_modify?(attribute).nil?
    end
    save
  end
  
  def can_modify?(attribute)
    case attribute.to_sym
      when :login
        return true if self.admin || self.moderator
      when :name
        return true unless self.client
      when :password
        return true unless self.client
      when :password_confirmation
        return true unless self.client
      when :admin
        return true unless self.client
      when :client
        return true unless self.client
      when :moderator
        return true unless self.client
      when :participant
        return true unless self.client
      else
        return true
    end
  end

  protected




end
