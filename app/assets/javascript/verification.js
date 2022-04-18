//= require moment
//= require simple_form-datetimepicker

$(document).ready(function() {

    toggleVisibleApplicantComment = function () {
        var applicantComment = $("#applicant-comment");
        var selected = $(`#verification_reason`).val();

        if (selected == 'restore') {
            applicantComment.show();

        } else {
            applicantComment.hide();
        }
    }

    toggleVisibleApplicantComment();

    $('#verification_reason').change(toggleVisibleApplicantComment);
});


