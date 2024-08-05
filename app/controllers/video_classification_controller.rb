class VideoClassificationController < ApplicationController
  def index
    @result = $result_formated
    @submitted = true 

    puts "Result after session update: "
    puts @result
  end

  def classify
    uploaded_file = params[:file]
    File.open(Rails.root.join('tmp', uploaded_file.original_filename), 'wb') do |file|
      file.write(uploaded_file.read)
    end

    # Call the Python script with the uploaded video file path as an argument
    result = `python3 lib/scripts/video_classificationLSTM.py #{Rails.root.join('tmp', uploaded_file.original_filename)}`

    # Extract the predicted postures as a string array
    predicted_postures = extract_predicted_postures(result)

    puts "Predicted Postures: "
    puts predicted_postures

    # Store the predicted postures in $result_formated
    $result_formated = predicted_postures

    redirect_to action: :index
  end

  private

  def extract_predicted_postures(result)
    # Match postures enclosed in single quotes
    postures = result.scan(/'([^']+)'/).flatten
    postures.join(', ')
  end
end
