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
    when /the admin main page/
      admin_path
    when /the admin review setting page/
      admin_review_settings_path
    when /the edit admin review setting page/
      edit_admin_review_settings_path
    when /the reviews dashboard page/
      dashboard_reviews_path
    when /the current user edit password page/
      account_change_password_path
    when /the dashboard account fuck page/
      dashboard_account_path
    when /the edit secret question page/
      edit_dashboard_secrets_path
    when /the new secret question page/
      new_dashboard_secrets_path
    when /the reset password by question page/
      user_password_reset_by_question_path
    when /the forgot password page/
      new_user_password_path
    when /the reset by question page/
      user_password_reset_by_question_path
    when /the new secret question dashboard page/
      new_dashboard_secrets_path
    when /the edit secret question dashboard page/
      edit_dashboard_secrets_path
    when /the orders dashboard page/
      dashboard_orders_path
    when /the dashboard seles page/
      dashboard_sales_path
    when /the about dashboard sellers page/
      about_you_dashboard_sellers_path
    when /the seller "(.+)" srore products/
      store_seller_path(User.find_by_email($1))
    when /the reviews dashboard page/
      dashboard_reviews_path
    when /the dashboard address page/
      dashboard_addresses_path
    when /the seller store "(.+)"/
      store_seller_path(User.find_by_email($1))
    when /the @message message page/
      dashboard_message_path(@message)
    when /the dashboard message page "(.+)"/
      dashboard_message_path(Message.find_by_subject($1))
    when /the dashboard inbox page/
      dashboard_messages_path
    when /the favorite sellers dashboard page/
      sellers_dashboard_favorites_path
    when /the dashboard selling options page for @quote/
      dashboard_quote_selling_options_path(@quote)
    when /the sellers store quote by @quote/
      # FIXME: Change this not nice link
      seller_quote_path(:id => @quote.seller.id, :product_id => @quote.product.permalink, :quote_id => @quote.id)
    when /the dashboard page/
      dashboard_root_path
    when /the dashboard quotes (.+) page/
      state_dashboard_quotes_path($1)
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
