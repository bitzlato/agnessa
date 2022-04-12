//=require 'jquery'

$(document).ready(function() {

  const FORM_QUERY='form.new_verification'

  setFormSubmitDisabled = function(){
    var disabled = true
    var validFields = $(`${FORM_QUERY} input:invalid`).length == 0;
    var validSelects = $(`${FORM_QUERY} select:invalid`).length == 0;
    var validFiles = $(`${FORM_QUERY} input:file`)[0].files.length >= 3;

    if (validFields && validFiles && validSelects) {
      disabled = false;
    }

    $(`${FORM_QUERY} input[type="submit"]`).attr({disabled: disabled});
  }

  setFormSubmitDisabled();

  $(`${FORM_QUERY} input`).change(function() {
    setFormSubmitDisabled();
  })

  $(`${FORM_QUERY} select`).change(function() {
    setFormSubmitDisabled();
  })
});


