class SinglesController < ApplicationController
  before_action :authenticate_user!, only: [:create, :update_title, :update_subtitle, :delete]
  before_action :allowed_user, only: [:update_title, :update_subtitle, :delete]

  # Ajax
  # Create Designs based on user image uploads, creating images, thumbs, filenames
  # Params (through rails params):
  # +design_images+:: <ActionController::Parameters>
  # Returns
  # @design <Design> with the design created
  # @images_added <Array> containing all the images created through params[:design_images]
  def create

    require 'RMagick'
    @images_added = []

    # params[:design_images] is set by a js library (Dropzone.js) and defined on dynamic_pages.js paramName
    params[:design_images].each do |array_file|

      # uploaded file example
      # {"0"=>#<ActionDispatch::Http::UploadedFile:0x007f88cf70b728 @tempfile=#<Tempfile:/var/folders/tx/fcpjq87x6b19sl3dvvm8fr040000gn/T/RackMultipart20150803-99318-18nmoiu.jpg>, @original_filename="10881656_10201963394846606_706439852029346946_n.jpg", @content_type="image/jpeg", @headers="Content-Disposition: form-data; name=\"singular_design[0]\"; filename=\"10881656_10201963394846606_706439852029346946_n.jpg\"\r\nContent-Type: image/jpeg\r\n">, "1"=>#<ActionDispatch::Http::UploadedFile:0x007f88cf70b610 @tempfile=#<Tempfile:/var/folders/tx/fcpjq87x6b19sl3dvvm8fr040000gn/T/RackMultipart20150803-99318-1loctd5.jpg>, @original_filename="11062261_825163280904553_6934851262428256525_n.jpg", @content_type="image/jpeg", @headers="Content-Disposition: form-data; name=\"singular_design[1]\"; filename=\"11062261_825163280904553_6934851262428256525_n.jpg\"\r\nContent-Type: image/jpeg\r\n">}

      uploaded_file = array_file.last

      # file checking (size and filetype)
      return false if !valid_img? uploaded_file

      # main image random filename
      random_filename = build_filename(uploaded_file)

      image = Magick::Image.from_blob(uploaded_file.read).first
      original_width = image.columns # columns are pixels
      original_height = image.rows # rows are pixels

      # just resize if image is larger in width
      image = image.resize_to_fit(2000, original_height) if original_width >= 2000
      image.write(Rails.root.join('public', 'assets', 'uploads','designs', random_filename))

      # thumbnail image random filename
      thumb_random_filename = build_filename(uploaded_file, true)
      thumbnail = image.resize_to_fill(250, 150)
      thumbnail.write(Rails.root.join('public', 'assets', 'uploads','designs', thumb_random_filename))

      # generating link for this new design
      random_link = SecureRandom.hex(4)

      while Design.exists?(link: random_link) == true do random_link = SecureRandom.hex(4) end

      @design = Design.new(user_id: current_user.id,
                           link: random_link,
                           image_path: random_filename,
                           image_thumb_path: thumb_random_filename)

      @images_added << @design if @design.save
    end

    respond_to do |format|
      format.html { redirect_to :individuais }
      format.json { render json: @images_added }
    end
  end

  # the main action where the magic occurs :)
  # Params (through rails params):
  # +design_link+:: <ActionController::Parameters>
  # Returns
  # @design <Design>
  def show

    @design = Design.find_by(link: params[:design_link])

    unless @design
      flash[:notice] = 'Nenhum design foi encontrado.'
      redirect_to root_url and return
    end

    if user_signed_in?
      @spots = @design.spots
    else
      session['design_id_before_register'] = @design.id
      session['design_username_before_register'] = @design.user.name
      redirect_to new_user_registration_path and return
    end
  end

  # AJAX
  # action triggered by registered users where they can send messages to admin (tips, problems, request and so on)
  def feedback_app
    @feedback_text = params[:feedback_text]
    respond_to do |format|
      FeedbackMailer.to_admin(@feedback_text, current_user).deliver_now
      format.js { render template: 'singles/feedback_app.js.erb' }
    end
  end

  # the delete action to remove the single
  def delete
    @design = Design.find(params[:design_id])
    @design.destroy
    flash[:notice] = 'Imagem deletada com sucesso'
    redirect_to individuais_path
  end

  # AJAX
  # name says it all. token is being sent by the request object (not by the form) jquery-rails take care of it (csrf in  <head>)
  def update_title
    return if params[:design_id].nil?

    @design = Design.find(params[:design_id])
    @design.title = params[:design_title]

    respond_to do |format|
      if @design.save
        format.html { redirect_to :back }
        format.js { render template: 'singles/update_title.js.erb' }
      else
        format.html { redirect_to root_path, notice: 'Erro ao atualizar o titulo do design.' }
      end
    end
  end

  # AJAX
  # name says it all. token is being sent by the request object (not by the form) jquery-rails take care of it (csrf in  <head>)
  def update_subtitle
    return if params[:design_id].nil?

    @design = Design.find(params[:design_id])
    @design.subtitle = params[:design_subtitle]

    respond_to do |format|
      if @design.save
        format.html { redirect_to :back }
        format.js { render template: 'singles/update_subtitle.js.erb' }
      else
        format.html { redirect_to root_path, notice: 'Erro ao atualizar o subtítulo do design' }
      end
    end
  end

  private

    # Create a random filename based on file, thumb and current_user.id
    # Params:
    # +file+:: <ActionDispatch::Http::UploadedFile>
    # +thumb+:: <Boolean>
    # Returns
    # <String> containing the full filename: ex. image-1.png, mythumb-thumb-2.jpg
    def build_filename(file, thumb = false)
      if thumb
        new_filename = SecureRandom.hex(8).to_s + '-thumb-' + current_user.id.to_s
      else
        new_filename = SecureRandom.hex(8).to_s + '-' + current_user.id.to_s
      end

      extension = if (file.content_type == 'image/png')
                    '.png'
                  elsif (file.content_type == 'image/jpeg')
                    '.jpeg'
                  elsif (file.content_type == 'image/jpg')
                    '.jpg'
                  end
      return new_filename + extension
    end

    # Check if the user is allowed and redirect to root_url if not
    def allowed_user
      unless current_user.id == Design.find(params[:design_id]).user.id
        flash[:notice] = 'Voce não tem permissão para fazer isso!'
        redirect_to root_url
      end
    end

    # Check image validity based on file size and type
    # Params:
    # +file+:: <ActionDispatch::Http::UploadedFile>
    # Returns
    # <Boolean> true if everything went well
    # <StandardError> if it fails
    def valid_img?(file = nil)
      return nil if file.nil?

      # checking file size
      if file.size > 25000000
        p "#{uploaded_file.last.size} bigger than 25MB"
        raise StandardError, 'Uploaded File Size Exceeded'
      end

      # checking file type
      unless file.content_type == 'image/jpeg' || file.content_type == 'image/jpg' || file.content_type == 'image/png'
        raise StandardError, 'Not Permitted Filetype'
      end

      return true
    end

end
