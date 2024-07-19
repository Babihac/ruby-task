module.exports = {
  content: [
    "./app/views/**/*.html.erb",
    "./app/views/**/*.html.slim",
    "./app/helpers/**/*.rb",
    "./app/assets/stylesheets/**/*.css",
    "./app/javascript/**/*.js",
    "./config/initializers/form_errors.rb",
    "./config/initializers/simple_form.rb",
  ],
  plugins: [require("daisyui")],
};
