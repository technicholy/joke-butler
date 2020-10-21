class User < ActiveRecord::Base
  has_many :messages
  has_many :jokes, through: :messages
end