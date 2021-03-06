require 'bcrypt'
require 'dm-validations'

class User
   include DataMapper::Resource

   attr_reader :password
   attr_accessor :password_confirmation

   property :id,               Serial
   property :user_name,        String, required: true, unique: true
   property :user_email,       String, required: true, unique: true
   property :password_digest,  Text

   has n, :messages

   validates_format_of :user_email, as: :email_address
   validates_confirmation_of :password

    def password=(password)
       @password = password
       self.password_digest = BCrypt::Password::create(password)
    end

    def self.authenticate(email, password)
      user = first(user_email: email)
      if user && BCrypt::Password.new(user.password_digest) == password
          user
        else
          nil
      end
    end

end
