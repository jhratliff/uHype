class PasswordsController < ActionController::Base
  respond_to :json

  def reset_password

    reason = 'bar reason'
    status = 'foo status'
    email_address = params[:lost_password_email]

    puts ("@@@@@@@@@@@ lost password email is: #{params[:lost_password_email]} ")

    if(!email_address.nil?)
      puts ("@@@@@@@@@@@ password is not nil ")

      status = 'Success'
      reason = "Check your email (#{email_address}) for the updated password"

    else
      puts ("@@@@@@@@@@@ password is nil ")
      status = 'Error'
      reason = 'Empty email address was sent'
    end

    @response = {:status => status, :reason => reason}

    respond_with(@response)

  end
end
