class MessagesController < ApplicationController
  before_action :set_message, only: [:show, :edit, :update, :destroy, :viewed_time]

  # GET /messages
  # GET /messages.json
  def index
    @messages = Message.all
  end

  # GET /messages/1
  # GET /messages/1.json
  def show
  end

  # GET /messages/new
  def new
    @message = Message.new
  end

  # GET /messages/1/edit
  def edit
  end

  # POST /messages
  # POST /messages.json
  def create
    @message = Message.new(message_params)
    @message.user = current_user

    @recipient = User.find(@message.recipient_id)

    puts ">>>>>>>>>>>>>> Message Create from #{current_user.id}: #{current_user.first_name} #{current_user.last_name} to #{@recipient.id}: #{@recipient.first_name} #{@recipient.last_name}"


    if @message.detail.nil? or @message.detail.empty?
      @recipient.send_alert(current_user.first_name + " " + current_user.last_name + ": sent a media file")
    else
      @recipient.send_alert(current_user.first_name + " " + current_user.last_name + ": " + @message.detail)
    end


    @recipient.increment_badge

    @message.save

    # puts "JHRLOG: new snapshot is created, lacking the image"
    # if params[:message]
    #   puts "JHRLOG: >>>>>> MESSAGE"
    # end
    #
    # if params[:message][:media_path]
    #   puts "JHRLOG: >>>>>> MESSAGE and MEDIA PATH"
    # end
    #
    # if params[:message][:media_path]["media_file"]
    #   puts "JHRLOG: >>>>>> MESSAGE and MEDIA PATH and MEDIA FILE"
    # end
    #
    #

    #check if file is within picture_path
    # if(params.has_key?(:message) && params.has_key?(:media_path) && params.has_key?("media_file"))


    if params[:message] && params[:message][:media_path] && params[:message][:media_path]["media_file"]
      # puts "JHRLOG: found a file entry"

      incoming_filename = params[:message][:media_path][:filename]


      media_path_params = params[:message][:media_path]

      #create a new tempfile named fileupload

      tempfile = Tempfile.new(incoming_filename, Rails.root.join('tmp'))

      # puts"JHRLOG: tempfile opened at #{tempfile.path}"

      tempfile.binmode
      # puts"JHRLOG: tempfile binmode set"

      # the buffer may be coming in with a base64 descriptor... trim it off the front
      # base64file = snapshot_path_params["snapshot_file"].partition(',').last
      base64file = media_path_params["media_file"]


      #get the file and decode it with base64 then write it to the tempfile
      tempfile.write(URI::unescape(Base64.decode64(base64file)))

      # puts "JHRLOG: tempfile size after decode64 is #{tempfile.size}"

      #create a new uploaded file
      uploaded_file = ActionDispatch::Http::UploadedFile.new(:tempfile => tempfile, :filename => incoming_filename, :original_filename => incoming_filename)

      # puts "JHRLOG: uploaded file object has been created "

      #replace photo element with the new uploaded file
      # params[:snapshot][:photo] = uploaded_file

      @message.media = uploaded_file
      @message.timer_left = 8

      # puts "JHRLOG: snapshot has been assigned an upload image"
      if @message.save
        # puts "JHRLOG: snapshot has been saved with the image"
        tempfile.unlink
      end


    end

    # puts "JHRLOG: after the base64 file processing"

    respond_with(@message)
  end

  # PATCH/PUT /messages/1
  # PATCH/PUT /messages/1.json
  def update
    respond_to do |format|
      if @message.update(message_params)
        format.html { redirect_to @message, notice: 'Message was successfully updated.' }
        format.json { render :show, status: :ok, location: @message }
      else
        format.html { render :edit }
        format.json { render json: @message.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /messages/1
  # DELETE /messages/1.json
  def destroy
    @message.destroy
    respond_to do |format|
      format.html { redirect_to messages_url, notice: 'Message was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  # POST /messages/:id/time
  def viewed_time

    puts "####### inside viewed_time"

    if params[:timer_left]
      puts '********** found a value, saving it'
      @message.timer_left = params[:timer_left]
      @message.save
      respond_with(@message)
    end
  end


  # returns the chat conversation between the recipient and me in ascending order
  # input expects a recipient_id value in the params array
  def chat
    partner = User.find(params[:recipient_id])

    # sort descending
    # (Message.where(:user => u, :recipient =>p) + Message.where(:user => p, :recipient => u)).sort_by{|e| -e[:id]}

    @messages = (Message.where(:user => current_user, :recipient =>partner) + Message.where(:user => partner, :recipient => current_user)).sort_by{|e| e[:id]}
    respond_with(@messages)
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_message
      @message = Message.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def message_params
      params.require(:message).permit(:user_id, :recipient_id, :detail, :media, :media_cache)
    end
end
