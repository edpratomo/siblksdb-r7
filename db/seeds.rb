# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)
fullname, username, email, password = ENV['DEVISE_FIRST_USER'].split(",").map(&:strip)
group = Group.find_by(name: "sysadmin")
raise "Group not found" unless group
user = User.new(fullname: fullname, username: username, group: group, email: email, password: password, password_confirmation: password)
user.save(validate: false)
