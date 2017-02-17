module Import
  
  
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
end