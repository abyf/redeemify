module Import
  
  def upload_page
  end
  
  def import
    if params[:file].nil?
     
      redirect_to "/#{params[:controller]}/upload_page",
        :flash => { :error => "You have not selected a file to upload" }
    else
    # params[:file] - uploaded file (file in vendor.rb)
    # current_offeror - offeror (current in vendor.rb)
    # params[:comment] - comment when we filling in the uploading form (comment in vendor.rb)
    # singularize("#{params[:controller]}") was corresponding to type in vendor.rb
    # We can delete it now
    # Let's check RSpec   ok
      import_status = Vendor.import(params[:file], current_offeror,
                    params[:comment])
  
      fail_codes = import_status[:err_codes]
      if import_status[:err_file]
        flash[:error] = import_status[:err_file]
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
