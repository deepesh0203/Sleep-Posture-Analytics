class BreathingRateController < ApplicationController
  def index
    @plot_image_path = plot_image_breathing_rate_index_path
  end

  def generate_plot
    uploaded_file = params[:file]
    
    if uploaded_file.present?
      begin
        # Delete existing plot.png if it exists
        plot_path = Rails.root.join('tmp', 'plot.png')
        File.delete(plot_path) if File.exist?(plot_path)

        filename = sanitize_filename(uploaded_file.original_filename)
        file_path = Rails.root.join('tmp', filename)
        File.open(file_path, 'wb') do |file|
          file.write(uploaded_file.read)
        end
        
        python_script_path = Rails.root.join('lib', 'scripts', 'breathing_rate.py')
        system("python #{python_script_path} #{file_path}")

        if File.exist?(plot_path)
          flash[:success] = "Plot generated successfully."
        else
          flash[:error] = "Plot generation failed. Please check the Python script."
        end
      rescue => e
        flash[:error] = "Error generating plot: #{e.message}"
      end
    else
      flash[:error] = "No file uploaded."
    end
    
    redirect_to action: :index
  end

  def plot_image
    plot_path = Rails.root.join('tmp', 'plot.png')
    if File.exist?(plot_path)
      send_file plot_path, type: 'image/png', disposition: 'inline'
    else
      render plain: "Plot not found", status: :not_found
    end
  end

  private

  def sanitize_filename(filename)
    filename.gsub(/[^0-9A-Za-z.\-]/, '_')
  end
end
