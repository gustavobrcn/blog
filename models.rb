class User < ActiveRecord::Base
    validates :first_name, :last_name, :birthday, :sex, :username, :email, :password, presence: true
    validates :email, :username, uniqueness: true
    validates :password, length: {minimum: 5, maximum: 8}

    has_many :posts, dependent: :destroy
end

class Post < ActiveRecord::Base
    validates :content, presence: true

    belongs_to :user
end
