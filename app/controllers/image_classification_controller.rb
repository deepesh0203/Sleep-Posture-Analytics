class ImageClassificationController < ApplicationController
  def index
    @result = session[:result_formated]
    @image_path = session[:image_path]
    @submitted = @result.present? && @image_path.present?
  end

  def classify
    uploaded_file = params[:file]
    file_path = Rails.root.join('tmp', uploaded_file.original_filename)
    File.open(file_path, 'wb') do |file|
      file.write(uploaded_file.read)
    end
  
    result = `python3 lib/scripts/image_classification.py #{file_path} 2>&1`
  
    if result.blank?
      Rails.logger.error "Python script did not return any output."
      redirect_to action: :index, alert: 'There was an error processing the file. Please try again.'
      return
    end
  
    output_lines = result.split("\n")
    Rails.logger.debug "Python script output: #{output_lines}"
  
    predicted_class_line = output_lines.find { |line| line.start_with?("Predicted class:") }
    image_path_line = output_lines.find { |line| line.start_with?("Image path:") }
  
    if predicted_class_line.nil? || image_path_line.nil?
      Rails.logger.error "Python script output missing expected lines. Output: #{output_lines}"
      redirect_to action: :index, alert: 'There was an error processing the file. Please try again.'
      return
    end
  
    predicted_class = predicted_class_line.split(":").last.strip
    image_path = image_path_line.split(":").last.strip
  
    session[:result_formated] = predicted_class
    session[:image_path] = image_path
  
    ActionCable.server.broadcast 'image_updates', {
      result_formated: predicted_class,
      image_path: image_path
    }
  
    redirect_to action: :index
  end
  def serve_tmp_image
    image_path = params[:path]
    send_file Rails.root.join(image_path), disposition: 'inline'
  end
end