healthChildcare.messageTemplate = {

  wysiwygEditor: function() {
    $('#message_template_content').froalaEditor();
  },

  datepickers: function() {
    $('#start_date').datetimepicker({
      format: 'd/m/Y',
      timepicker: false
    });

    $('#end_date').datetimepicker({
      format: 'd/m/Y',
      timepicker: false
    });
  },

  editMessageTemplates: function() {

    $('select#subject_id').on('change', function() {
      var subjectId = $(this).val();
      var subSubjects = $('#sub-subject-filter').find('select option[data-parent_id="' + subjectId + '"]');
      var subSubjectsValue = $.map(subSubjects, function(a) {return parseInt($(a).val())});

      var dropdownjsList = $('#sub-subject-filter').find('.dropdownjs ul li');

      $.each(dropdownjsList, function(idx, subSubjectLi) {
        li = $(subSubjectLi);

        if ($.inArray(li.val(), subSubjectsValue) > -1) {
          li.show();
        }
        else {
          li.hide();
        }

      });

    });

  }
}
