# == Schema Information
#
# Table name: users
#
#  id              :bigint(8)        not null, primary key
#  username        :string
#  password_digest :string
#  session_token   :string
#  created_at      :datetime         not null
#  updated_at      :datetime         not null
#
require 'bcrypt'
class User < ApplicationRecord

    validates :username, presence: true, uniqueness: true
    validates :password_digest, presence: {message: "Password can't be blank"}
    validates :password, length: {minimum: 6, allow_nil: true}
    after_initialize :session_token
    attr_reader :password

    has_many :cats,
    foreign_key: :user_id,
    class_name: :Cat

    has_many :requests,
    foreign_key: :user_id,
    class_name: :CatRentalRequest,
    dependent: :destroy


    def self.find_by_credentials(username, password)
        user = User.find_by(username: username)
        return nil if user.nil? || !user.is_password?(password)
        user
    end

    def reset_session_token!
        self.session_token = SecureRandom::urlsafe_base64(16)
        self.save!
        self.session_token
    end

    def password=(password)
        @password = password
        self.password_digest = BCrypt::Password.create(password)
    end

    def is_password?(password)
        BCrypt::Password.new(self.password_digest).is_password?(password)
    end

    
end
