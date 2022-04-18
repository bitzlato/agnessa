document.addEventListener("turbolinks:load", function() {
    addLabelsToPublicComment = function () {
        var selected = $(`#verification_review_result_labels option:selected`);

        var textarea =  $("#verification_public_comment");
        textarea.val('');
        $.each(selected, function( i, l ){
            var append =  $(l).data('publicComment')+"\n"
            textarea.val(textarea.val() + append);
        });
    }

    $('#verification_review_result_labels').change(addLabelsToPublicComment)
});


