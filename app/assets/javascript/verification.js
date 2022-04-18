//= require turbolinks
//= require moment
//= require simple_form-datetimepicker

const toggleVisibleApplicantComment = function () {
    var applicantComment = $("[data-applilcant-comment]");

    if (this.value == 'restore') {
        applicantComment.show();
    } else {
        applicantComment.hide();
    }
}

document.addEventListener("turbolinks:load", function() {
    toggleVisibleApplicantComment();
    $('[data-verification-reason]').change(toggleVisibleApplicantComment);
});


