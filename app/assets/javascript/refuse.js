$(document).ready(function() {

    const FORM_QUERY='#verification_review_result_labels'

    addLabelsToPublicComment = function () {
        var selected = $(`${FORM_QUERY} option:selected`);

        var textarea =  $("#verification_public_comment");
        textarea.val('');
        $.each(selected, function( i, l ){
            var append =  $(l).data('publicComment')+"\n"
            textarea.val(textarea.val() + append);
        });
    }


    $(`${FORM_QUERY}`).change(function() {
        addLabelsToPublicComment()
    })
});


