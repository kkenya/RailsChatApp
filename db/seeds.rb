require 'csv'

CSV.foreach('db/users.csv') do |row|
  User.create!(name: row[0], email: row[1], password: 'password', password_confirmation: 'password')
end

