class PasswordsController < ActionController::Base
  respond_to :json

  def reset_password

    reason = 'bar reason'
    status = 'foo status'
    email_address = params[:lost_password_email]

    puts ("@@@@@@@@@@@ lost password email is: #{params[:lost_password_email]} ")

    if(!email_address.nil?)
      puts ("@@@@@@@@@@@ password is not nil ")




      Mail.deliver do
        to 'jamesr@gmail.com'
        from 'uHype <noreply@uhype.net>'
        subject 'This is the subject of your email'
        text_part do
          body 'Hello world in text'
        end
        html_part do
          content_type 'text/html; charset=UTF-8'
          body '<b>Hello world in HTML</b>'
        end
      end




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
