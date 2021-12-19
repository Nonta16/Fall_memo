require 'bundler/setup'
Bundler.require

ActiveRecord::Base.establish_connection

class User < ActiveRecord::Base
    has_secure_password
    validates :password,
      length: { in: 5..10 }
    validates :email,
      presence: true,
      format: { with:/\A.+@[a-zA-Z0-9-]+(?:\.[a-zA-Z0-9-]+)+\z/ }
    has_many :contributions
end

class Contribution < ActiveRecord::Base
    belongs_to :user
end
