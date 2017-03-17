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
  	def self.import(file, current, comment)
        
        processed_codes, approved_codes, date = { submitted_codes: 0 }, 0, ""
        
        processed_codes[:err_file] = file_check file.path
        return processed_codes if processed_codes[:err_file]
        
    	f = File.open(file.path, "r")
		f.each_line do |row|
			row = row.gsub(/\s+/, "") # gsub eliminates spaces in a row
			if row !=  ""
			  processed_codes[:submitted_codes] +=1
			  begin
			  a = add_code(current, row)
			  a.save!
			  approved_codes += 1
			  rescue
			    err_str = a.errors[:code].join(', ')
			    processed_codes[err_str] ||=[]
			    processed_codes[err_str] << a.code
			  end
			    processed_codes[:err_codes] = processed_codes[:submitted_codes] - approved_codes
			end
		end
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
  		# It's a long method but it's purpose also very simple
  		# The essense is in lines 143-145
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

  	def self.homeSet(histories)
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
			if offeror.is_a? Vendor
 				offeror.vendorCodes.build(code: code, name: offeror.name,
 					vendor: offeror)
 			else
 				offeror.redeemifyCodes.build(code: code, name: offeror.name,
 					provider: offeror)
			end
  	end
end
