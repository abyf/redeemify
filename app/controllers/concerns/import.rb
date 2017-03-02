module Import
  
  def upload_page
  end  
  
  def import
    if params[:file].nil?
      # unique path; our goal is to generalize it depending on the controller
      redirect_to "/#{params[:controller]}/upload_page",
        :flash => { :error => "You have not selected a file to upload" }
    else
      # Here we invoking Vendor.import method with four parameters,
        # one of which is unique - current_vendor
      import_status = Vendor.import(params[:file], current_offeror,
                    params[:comment], singularize("#{params[:controller]}"))
      # the original method in Vendor model (/app/models/vendor.rb, line 15)
      # def self.import(file, current, comment, type)
      # We invoke this method here, on line 12
      # 'type' (fourth argument) is just a string ("vendor" or "provider")
      # To make the solution general we can singularize the controller's name
      # singularize("#{params[:controller]}"), since the params[:controller] == "providers" (plural)
      # But we want "provider" (singular)
      # To make it work we have to include ActiveSupport::Inflector class
      # http://api.rubyonrails.org/classes/ActiveSupport/Inflector.html
      # Let's include it in providers_controller.rb and vendors_controller.rb
      fail_codes = import_status[:err_codes]
      if import_status[:err_file]
        flash[:error] = import_status[:err_file]
        # this one
        redirect_to "/#{params[:controller]}/upload_page"      
      elsif fail_codes > 0
        content = validation_errors_content(import_status)
        send_data(content, :filename => "#{fail_codes}_#{'code'.pluralize(fail_codes)}_rejected_at_submission_details.txt")
      else
        flash[:notice] = "#{import_status[:submitted_codes]} #{'code'.pluralize(import_status[:submitted_codes])} imported"
        # And this one we also have change
        redirect_to "/#{params[:controller]}/home"
      end
    end
  end
  
  def home
    @histories_array = []

    if current_offeror.history != nil
      # @histories_array instantiated by invoking Vendor.homeSet mathod
      # Open vendor.rb, line 99
      # app/models/vendor.rb
      @histories_array = Vendor.homeSet(current_offeror.history)
    end

    @hash = { "uploaded" => current_offeror.uploadedCodes,
              "used" => current_offeror.usedCodes,
              "unclaim" => current_offeror.unclaimCodes,
              "removed" => current_offeror.removedCodes }

    gon.codes = @hash
    gon.history = current_offeror.history
  end
 
  def clear_history
    if current_offeror.history.nil?
      redirect_to "/#{params[:controller]}/home", :flash => { :error => "History is empty" }
    else
      current_offeror.update_attribute(:history, nil)
      redirect_to "/#{params[:controller]}/home", notice: "Cleared History"
    end
  end
    
    
  # Provider-Cont
  # The new problem is uniqueness of this construction
  # current_provider.redeemifyCodes
  # We can use current_offeror instead of current_provider or current_vendor,
  # but how to deal with codes  It's where I got stucked on Friday
  # Think about the meaning
  # It is codes of the current_offeror
  # We can define new method in application controller
  # The parent controller for all controllers
  # def offeror_codes
  # Open app/controllers/application_controller.rb
  def remove_codes
    flag = offeror_codes.where(:user_id => nil)
    if flag.count == 0
      redirect_to "/#{params[:controller]}/home",
      :flash => { :error => "There's No Unclaimed Codes" }
    else
      contents = Vendor.remove_unclaimed_codes(current_offeror, singularize("#{params[:controller]}"))
      send_data contents, :filename => "Unclaimed_Codes.txt"
    end
  end 
end






