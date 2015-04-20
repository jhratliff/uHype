class PasswordsController < ActionController::Base
  respond_to :json

  def reset_password

    reason = 'bar reason'
    status = 'foo status'
    email_address = params[:lost_password_email]

    # puts ("@@@@@@@@@@@ lost password email is: #{params[:lost_password_email]} ")

    if(!email_address.nil?)
      # puts ("@@@@@@@@@@@ password is not nil ")

      user = User.find_by_email(email_address)

      if user

        new_password = (0...8).map { (65 + rand(26)).chr }.join

        user.password = new_password
        user.save

        # As a hash
        client = SendGrid::Client.new(api_user: ENV['SENDGRID_USERNAME'], api_key: ENV['SENDGRID_PASSWORD'])


        mail = SendGrid::Mail.new do |m|
          m.to = email_address
          m.from = 'noreply@uhype.net'
          m.subject = 'Here is your new uHype password'
          m.text = 'Your new password is ' + new_password
        end

        client.send(mail)



        status = 'Success'
        reason = "Check your email (#{email_address}) for the updated password"

      else

        status = "Error"
        reason = "Email address was not found"
      end


    else
      status = 'Error'
      reason = 'Empty email address was sent'
    end

    @response = {:status => status, :reason => reason}

    respond_with(@response)

  end
end
