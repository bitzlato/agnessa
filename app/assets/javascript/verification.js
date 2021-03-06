//= require moment
//= require simple_form-datetimepicker
//= require bootstrap-sprockets
//= require rails-ujs


const toggleVisibleApplicantComment = function () {
    var applicantComment = $("[data-applicant-comment]");

    if (this.value == 'restore') {
        applicantComment.show();
    } else {
        applicantComment.hide();
    }
}
$( document ).ready(function() {
    toggleVisibleApplicantComment();
    $('[data-verification-reason]').change(toggleVisibleApplicantComment);
});
