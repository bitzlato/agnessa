//= require rails-ujs
//= require turbolinks
//  require better-dom
//  require better-dateinput-polyfill/dist/better-dateinput-polyfill.min.js
// require moment
// require bootstrap
// require bootstrap4-datetimepicker/build/js/bootstrap-datetimepicker.min
// require selectize.js
// require simple_form_extension
// require simple_form_extension/selectize
//= require_tree ./elements
//= require_tree ./extra

document.addEventListener("turbolinks:load", function() {
  const verification_callback_form = document.querySelector("#verification_callback_form");
  const verification_callback_form_result = document.querySelector("#verification_callback_result");

  verification_callback_form.addEventListener("ajax:beforeSend", (event) => {
    verification_callback_form_result.innerHTML = '<div class="spinner-border"><span class="sr-only">Loading...</span></div>';
  });
  verification_callback_form.addEventListener("ajax:success", (event) => {
    const [_data, _status, xhr] = event.detail;
    verification_callback_form_result.innerHTML = xhr.responseText;
  });
  verification_callback_form.addEventListener("ajax:error", () => {
    verification_callback_form_result.innerHTML = "<p>ERROR</p>";
  });
  
//   $('[data-toggle="tooltip"]').tooltip()
//   $('.datetimepicker').datetimepicker({
//      format: 'YYYY-MM-DD HH:mm'
//   })
})
