class User < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :encryptable, :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable,
         :token_authenticatable, :omniauthable

  before_save :ensure_authentication_token
  validates_uniqueness_of :username
  validates_format_of :username, :with => /^[A-Za-z\d_]+$/, message:
            "Required. Display name must only be letters, numbers, dashes, or underscores"

  attr_accessible :email, :password, :password_confirmation,
                  :remember_me, :username
  
  has_many :authentications, :dependent => :destroy

  has_many :growls, :dependent => :destroy
  has_many :images
  has_many :messages
  has_many :links

  def relation_for(type)
    self.send(type.downcase.pluralize.to_sym).scoped rescue text_posts.scoped
  end

  def twitter_client
    return nil unless twitter_oauth = authentications.where(provider: "twitter").first

    # XXX what if they have multiple twitters?
    Twitter::Client.new(:consumer_key => TWITTER_KEY,
                        :consumer_secret => TWITTER_SECRET,
                        :oauth_token => twitter_oauth.token,
                        :oauth_token_secret => twitter_oauth.secret)
  end

  def send_welcome_message
    mail = UserMailer.welcome_message(self)
    mail.deliver
  end
end
# == Schema Information
#
# Table name: users
#
#  id                     :integer         not null, primary key
#  email                  :string(255)     default(""), not null
#  encrypted_password     :string(255)     default(""), not null
#  reset_password_token   :string(255)
#  reset_password_sent_at :datetime
#  remember_created_at    :datetime
#  sign_in_count          :integer         default(0)
#  current_sign_in_at     :datetime
#  last_sign_in_at        :datetime
#  current_sign_in_ip     :string(255)
#  last_sign_in_ip        :string(255)
#  created_at             :datetime        not null
#  updated_at             :datetime        not null
#  username               :string(255)
#  authentication_token   :string(255)
#

