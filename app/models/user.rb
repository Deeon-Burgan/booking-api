class User < ApplicationRecord
    validates_uniqueness_of :email
    validates_presence_of :email, :name, :password_digest

    has_secure_password
end
