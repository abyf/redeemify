class Vendor < ActiveRecord::Base
	# require 'csv'
	has_many :vendorCodes

	before_create :defaultValue

	def defaultValue
		self.usedCodes = 0
		self.uploadedCodes = 0
		self.unclaimCodes = 0
		self.removedCodes = 0
	end
	
	# self means class name. Vendor.import in our case
	# with 4 arguments (file, current, comment, type)
	# Let's consider these arguments
	# The general purpose of this method is to upload file with codes and
	# optional comment
	# This method is in Vendor model, but used by both offerors - providers and
	# vendors
	# So, file is the txt file with codes in appropriate format (each code on a 
	# new line)
	# current means current offeror (who is authenticated)
	# current user with specific ID
	# comment is the comment
	# type determines the offeror type - vendor or provider
	# Is it clear?   Very clear
	# Let's inspect this method
	# Let me rename variables to make their purpose clearer
	# Controllers and models tightly connected
	# To refactor controller method we start with corresponding model method that
	# invoked by the offeror import method
	# You'll see later why we are doing this
	# Freddy? yes
	# I propose to eliminate fouth argument - type  Why?
	# Generally, with good architecture, method should have 1-2 arguments
	# If it has more, it means, that it includes more that one idea
	# When we inspect this method attentively, we'll find that
	# 'type' is a string argument with two reasonable values in our case -
	# "vendor" or "provider"
	# if "vendor" - one path
	# if "provider" - another path
	# We can improve it     hmmm
	# 1 minute please   ok
	# Look, when this argument is checked
	# Line 60
	# 
  	def self.import(file, current, comment)
        
        processed_codes, approved_codes, date = { submitted_codes: 0 }, 0, ""
        
        processed_codes[:err_file] = file_check file.path
        return processed_codes if processed_codes[:err_file]
        
        # Here we open uploaded file with codes
    	f = File.open(file.path, "r")
    	# process each line in a file
    	# by instruction in one line should be one code
		f.each_line do |row|
			row = row.gsub(/\s+/, "") # gsub eliminates spaces in a row
			if row !=  ""   # if row is empty, there are no code
			# we process only lines that are not empty
			# Any questions here?  I can't really put questions now, 
			# Continue then
			# Will be clearer later    ok
			# it is a hash, where :submitted_codes is key,
			# default value is 0, and
			# when we proceed every line, the number += 1
			# it will reflect the total number of processed lines (codes)
			# some of them will be rejected, other will be approved
			# the criterias defined in the models vendor_code.rb and
			# redeemify_codes.rb (validations)
			# Continue  
			# Start processing the file
			  processed_codes[:submitted_codes] +=1
			  begin
			  # here we can extract a method
			  # It's purpose is to add codes
			  # Let's name it add_code
			  # It will have 2 arguments - offeror and code
			  # Let's copy these lines and define the method below
			  # We have extracted the following functionality into add_code method
			  a = add_code(current, row)
			  a.save!
			  approved_codes += 1
			  # Thereby be have eliminated 'type' argument
			  # Now the type of offeror will be defined inside add_code method
			  # by the condition
			  # if offeror.is_a? Vendor
			  # if it returns true, then offeror is Vendor, else - Provider
			  rescue
			    err_str = a.errors[:code].join(', ')
			    processed_codes[err_str] ||=[]
			    processed_codes[err_str] << a.code
			  end
			    processed_codes[:err_codes] = processed_codes[:submitted_codes] - approved_codes
			end
		end # end CSV.foreach
		f.close
		history = current.history

	    date = Time.now.to_formatted_s(:long_ordinal)
	    if history == nil
	    	history = "#{date}+++++#{comment}+++++#{approved_codes}|||||"
	    else
	    	history = "#{history}#{date}+++++#{comment}+++++#{approved_codes}|||||"
	    end
	    current.update_attribute(:history, history)
	    current.update_attribute(:uploadedCodes, current.uploadedCodes + approved_codes)
	    current.update_attribute(:unclaimCodes, current.unclaimCodes + approved_codes)

        return processed_codes
        
  	end # end self.import(file)
  	
  	def self.file_check(file_path)
        return "Wrong file format! Please upload '.txt' file" unless file_path =~/.txt$/
        return "No codes detected! Please check your upload file" if File.zero? file_path
    end    

  	def self.update_profile_vendor(current_vendor,info)
  		current_vendor.update_attributes(:cashValue => info["cashValue"], :expiration => info["expiration"], :helpLink => info["helpLink"],:instruction => info["instruction"], :description => info["description"])
  	end # end self.profile()

  	def self.remove_unclaimed_codes(current, type)
  		unclaimed = ""
  		if type == "vendor"
  			unclaimedCodes=current.vendorCodes.where(:user_id => nil)
  		else
  			unclaimedCodes=current.redeemifyCodes.where(:user_id => nil)
  		end

  		num = current.unclaimCodes
  		date = Time.now.to_formatted_s(:long_ordinal)

  		history = current.history
  		history = "#{history}#{date}+++++Delete Codes+++++-#{num.to_s}|||||"
  		current.update_attribute(:history, history)

  		contents = "There're #{num} unclaimed codes, remove on #{date}\n\n"
  		unclaimedCodes.each do |code|
  			contents = "#{contents}#{code.code}\n"
  			code.destroy
  		end
  		current.update_attribute(:unclaimCodes, 0)
  		current.update_attribute(:removedCodes, current.removedCodes + num)

  		return contents
  	end

	# in our controller, in import.rb:
	# @histories_array = Vendor.homeSet(current_offeror.history)
	# look at line 102
	# 'current_offeror.history' substitutes 'histories' when we
	# invoke this method from the import.rb
  	def self.homeSet(histories)
  		# It means when we instantiate @histories_array in import.rb,
  		# we invoke this method with current_offeror.history as a parameter
  		# so, 
  		# to interpret next line:
  		# current_offeror.history = current_offeror.history.split("|||||")
  		# and so on
  		# where 'history' is the attribute of the providers/vendors instance,
  		# look at the db/schema.rb, line 54 (it's a column in database) yes
  		# Good!!! Let's continue  ok
		histories = histories.split("|||||")

		histories_array=[]
		histories.each do |history|
			temp = history.split("+++++")
			histories_array.push(temp)
		end
		histories_array.reverse!

	    return histories_array
  	end

    def serve_code(myUser)
    	code = self.vendorCodes.where(user: myUser).first || 
    	       self.vendorCodes.where(user: [0,nil]).first
        unless code.nil?
          if code.user_id.nil? && self.vendorCodes.find_by(user: myUser).nil?
            code.assign_to myUser
          end
        end
        code
    end
    
    private
    
  	def self.add_code(offeror, code)
  		# We have to check who is the offeror
  		# That's it
  		# Let's rewrite this line in more rubyistic way  ok
  		# Looks better
  		# Now we can back to our import method
			if offeror.is_a? Vendor
 				offeror.vendorCodes.build(code: code, name: offeror.name,
 					vendor: offeror)
 			else
 				offeror.redeemifyCodes.build(code: code, name: offeror.name,
 					provider: offeror)
			end
  	end
end
