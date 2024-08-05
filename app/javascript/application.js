// Configure your import map in config/importmap.rb. Read more: https://github.com/rails/importmap-rails
import "@hotwired/turbo-rails"
import "controllers"

//= require rails-ujs
//= require turbolinks
//= require action_cable
//= require_tree .

// Initialize ActionCable
(function() {
    this.App || (this.App = {});
  
    App.cable = ActionCable.createConsumer();
  
  }).call(this);
  