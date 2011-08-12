module NavigationHelpers
  # Maps a name to a path. Used by the
  #
  #   When /^I go to (.+)$/ do |page_name|
  #
  # step definition in web_steps.rb
  #
  def path_to(page_name)
    case page_name
    when /the sign up page/
      new_user_registration_path
    when /the sign in page/
      new_user_session_path
    when /the Products page/
      '/products'
    when /reset password page/
       new_user_password_path
    when /the user password/
      user_password_path
    when /the password reset page "([^\"]*)"$/
      edit_user_password_path($1)
    when /account page/
      account_path
    when /the dashboard quotes page/
      dashboard_quotes_path
    when /the admin static page/
      admin_pages_path
    when /the new admin static page/
      new_admin_page_path
    when /the static page "(.+)"/
      "/#{($1)}"
    when /the "(.+)" product page/
      product_path(Product.find_by_name($1).permalink)
    when /the new review page for product "(.+)"/
      new_product_review_path(Product.find_by_name($1).permalink)
    when /the "(.+)" review by url/
      "/products/#{Product.find_by_name($1).permalink}/reviews"
    when /top (.+) page/
      top_path($1)
    when /logout/
      destroy_user_session_path
    when /the "(.+)" edit password page/
      edit_user_password_path(User.find_by_email($1))
    when /^the new message page for seller "(.+)"/
      new_message_path(User.find_by_email($1))
    when /the show dashboard message page for "(.+)"/
      dashboard_message_path(Message.roots.find_by_subject($1))
    when /^the home\s?page$/
      '/'

    # Add more mappings here.
    # Here is an example that pulls values out of the Regexp:
    #
    #   when /^(.*)'s profile page$/i
    #     user_profile_path(User.find_by_login($1))

    else
      begin
        page_name =~ /^the (.*) page$/
        path_components = $1.split(/\s+/)
        self.send(path_components.push('path').join('_').to_sym)
      rescue NoMethodError, ArgumentError
        raise "Can't find mapping from \"#{page_name}\" to a path.\n" +
          "Now, go and add a mapping in #{__FILE__}"
      end
    end
  end
end

World(NavigationHelpers)
