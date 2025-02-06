class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :trackable, #:registerable,
         :recoverable, :rememberable, :validatable

  include Gravtastic
  gravtastic default: "identicon"

  belongs_to :group

  def admin?
    group.name == "sysadmin" or group.name == "admin"
  end

  def first_sysadmin?
    self.id == User.joins(:group).where("group.name": "sysadmin").order(:id).first.id
  end
  
  def self.options_for_group
    Group.where.not(name: "student").map {|e| [e.name, e.id]}
  end
end
