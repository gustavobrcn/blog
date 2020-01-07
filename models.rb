class User < ActiveRecord::Base
    validates :first_name, :last_name, :birthday, :sex, :username, :email, :password, presence: true
    validates :email, :username, uniqueness: true
    validates :password, length: {minimum: 5, maximum: 8}
end

class Posts < ActiveRecord::Base
    validates :content, presence: true
end
