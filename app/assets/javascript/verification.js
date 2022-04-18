//= require turbolinks
//= require moment
//= require simple_form-datetimepicker

document.addEventListener("turbolinks:load", function() {

        toggleVisibleApplicantComment = function () {

        var applicantComment = $("[data-applilcant-comment]");

        if (this.value == 'restore') {
            applicantComment.show();
        } else {
            applicantComment.hide();
        }
    }

    toggleVisibleApplicantComment();

    $('[data-verification-reason]').change(toggleVisibleApplicantComment);
});


