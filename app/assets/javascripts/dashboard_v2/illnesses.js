var Illnesses;

!function($) {
  'use strict';

  var Illnesses = Object.create({

    updateChildList: function() {
      var list = $('form#new-child-record').find('.choose-child .children-list');
      var deptId = $('input[name="child_department_id"]:checked').val();

      $.ajax({
        url: '/illnesses/department_children',
        data: {department_id: deptId},
        type: 'GET',
        success: function(data) {
          list.html(data);
          $.material.init();
        },
        error: function() {
          console.log('error');
        }
      })
    },

  });

  $(document).ready(function() {
    $('form#new-child-record')
      .on('change', 'input[name="child_department_id"]', Illnesses.updateChildList);

  })
}(jQuery);
