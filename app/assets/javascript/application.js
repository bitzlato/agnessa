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
//= require nprogress/nprogress
//= require refuse_append
//= require_tree ./elements
//= require_tree ./extra

document.addEventListener('turbolinks:click', function() {
  NProgress.start();
});

document.addEventListener('turbolinks:render', function() {
  NProgress.done();
  NProgress.remove();
});

document.addEventListener("turbolinks:load", function() {
  const verification_callback_form = document.querySelector("#verification_callback_form");
  const verification_callback_form_result = document.querySelector("#verification_callback_result");

  if (verification_callback_form) {
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
  }

//   $('[data-toggle="tooltip"]').tooltip()
//   $('.datetimepicker').datetimepicker({
//      format: 'YYYY-MM-DD HH:mm'
//   })


    addLabelsToPublicComment = function () {
      var selected = $(`#verification_review_result_labels option:selected`);

      var textarea =  $("#verification_public_comment");
      textarea.val('');
      $.each(selected, function( i, l ){
        var append =  $(l).data('publicComment')+"\n"
        textarea.val(textarea.val() + append);
      });
    }


    $(`#verification_review_result_labels`).change(function() {
      addLabelsToPublicComment()
    })
})
