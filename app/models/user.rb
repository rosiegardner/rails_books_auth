class User < ApplicationRecord
  attr_accessor :password
  validates_confirmation_of :password
  validates :email, :presence => true, :uniqueness => true
  before_save :encrypt_password

  def encrypt_password
    self.password_salt = BCrypt::Engine.generate_salt
    self.password_hash = BCrypt::Engine.hash_secret(password,password_salt)
  end

  def self.authenticate(email, password)
    user = User.find_by "email = ?", email
    if user && user.password_hash == BCrypt::Engine.hash_secret(password, user.password_salt)
      user
    else
      nil
    end
  end
end

# 1) First, we have attr_accessor :password. 
# Even though we don’t want to save passwords to the database, 
# we do need to temporarily store a user’s password when a user 
# signs up or logs in.
# 
#   A quick refresher: attr_accessor adds read and write methods
#   for a password attribute. This is called a virtual attribute 
#   because the attribute won’t actually be persisted to the database.

# 2) We also have two validations:

#   The first validates both the presence and uniqueness 
#   of the email field. We don’t want multiple accounts with
#   the same email so validating uniqueness is important.

#   The second validation checks that the user’s password has 
#   been confirmed. When we add a form later, 
#   we’ll use both a password field and a password_confirmation field.
#   We don’t want users to accidentally add typos to their passwords!

# 3) Next, we have a before_save callback that calls the encrypt_password
#    method before the user is saved to the database. 
#    This way a salt and hash are generated and then saved.

# 4) Our encrypt_password instance method uses two built-in bcrypt methods.
#    First, we use bcrypt to generate a salt. Then we use the hash_secret method
#    to mix password (our virtual attribute) with our generated password_salt. 
#    Once that’s complete, the user’s password_salt and password_hash will be 
#    saved to the database.

# 5) We also have an authenticate class method. 
#    We use a class method so we can do the following in our 
#    controllers: 
#    @user = User.authenticate(params[:email], params[:password]).

# 6) Our authenticate method makes a database query to find a user by 
#    the provided email address. If there’s a matching user in our database 
#    and if that user’s stored password_hash matches the entered password
#    (which has been hashed and salted like the stored value in the database),
#    then the method will return user. Otherwise, the method returns nil. 
#    This will become clearer when we add the code for sessions_controller.rb 
#    later in this lesson.