
# see last line where we create an admin if there is none, asking for email and password
def prompt_for_admin_password
  password = ask('Password [123456]: ', String) do |q|
    q.echo = false
    q.validate = /^(|.{5,40})$/
    q.responses[:not_valid] = "Invalid password. Must be at least 5 characters long."
    q.whitespace = :strip
  end
  password = "123456" if password.blank?
  password
end

def prompt_for_admin_email
  email = ask('Email [spree@example.com]: ', String) do |q|
    q.echo = true
    q.whitespace = :strip
  end
  email = "spree@example.com" if email.blank?
  email
end

def create_admin_user
  if ENV['AUTO_ACCEPT']
    password =  "123456"
    email =  "spree@example.com"
  else
    require 'highline/import'
    puts "Create the admin user (press enter for defaults)."
    #name = prompt_for_admin_name unless name
    email = prompt_for_admin_email
    password = prompt_for_admin_password
  end
  attributes = {
    :password => password,
    :password_confirmation => password,
    :email => email,
    :login => email,
    :firstname => Faker::Name.first_name,
    :lastname => Faker::Name.last_name
  }

  load 'user.rb'

  if User.find_by_email(email)
    say "\nWARNING: There is already a user with the email: #{email}, so no account changes were made.  If you wish to create an additional admin user, please run rake db:admin:create again with a different email.\n\n"
  else
    admin = User.create!(attributes)
    # create an admin role and and assign the admin user to that role
    role = Role.find_or_create_by_name "admin"
    admin.roles << role
    admin.save
  end
end

create_admin_user if User.where("roles.name" => 'admin').includes(:roles).empty?

User.where("email like :email", :email => "seller%").each do  |item|
  item.roles << Role.find_or_create_by_name(:seller)
  item.shipping_methods.create!({
                                 :calculator => Calculator::FlatRate.new,
                                 :name => "UPS GROUP",
                                 :virtual => false,
                                 :method_kind => ShippingMethod::METHOD_KIND_TO_ADDRESS,
                                 :zone => Zone.first

                               })
end

# User recalculate rating
Role.find_by_name('seller').users.each do |saller|
  saller.recalculate_rating
end

# Create default password for cool seller
User.find(101).update_attributes(:password => 'moloko', :password_confirmation => 'moloko')
