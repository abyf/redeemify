# TL;DR: YOU SHOULD DELETE THIS FILE
#
# This file is used by web_steps.rb, which you should also delete
#
# You have been warned
module NavigationHelpers
  # Maps a name to a path. Used by the
  #
  #   When /^I go to (.+)$/ do |page_name|
  #
  # step definition in web_steps.rb
  #
  def path_to(page_name)
    case page_name
      
    when /^the vendor upload page$/ then '/vendors/upload_page'
    when /^the code entry page$/ then '/sessions/enter'
    when /^the offers page$/ then '/sessions/customer'
    when /^the vendor page$/ then '/vendors/home'
    when /^the user login page$/ then root_path
    when /^the provider upload page$/ then '/providers/upload_page'
    when /^the admin login page$/ then '/admin/login'
    when /^the delete page$/ then '/sessions/delete_page'
    when /^the new session page$/ then '/sessions/new'
    when /^the provider page$/ then '/providers/home'
    when /^the vendor upload page$/ then '/vendors/upload_page'
    
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
