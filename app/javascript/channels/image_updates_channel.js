import consumer from "./consumer";

// app/assets/javascripts/channels/image_updates_channel.js
(function() {
  App.imageUpdates = App.cable.subscriptions.create("ImageUpdatesChannel", {
    connected: function() {
      console.log("Connected to ImageUpdatesChannel");
    },
    disconnected: function() {
      console.log("Disconnected from ImageUpdatesChannel");
    },
    received: function(data) {
      console.log("Received data:", data);
      document.getElementById('prediction_result').innerText = data.result_formated;
      document.getElementById('generated_image').src = `/serve_tmp_image?path=${data.image_path}`;
      let imagePath = `/serve_tmp_image?path=${data.image_path}`;
      console.log("Image path:", imagePath);
      
      document.getElementById('generated_image').src = imagePath;
    }
  });
}).call(this);
