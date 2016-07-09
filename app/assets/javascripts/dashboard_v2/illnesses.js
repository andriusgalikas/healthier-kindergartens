var Illnesses;

!function($) {
  'use strict';

  var Illnesses = Object.create({
    initSearchDepartment: function() {
      $('#search-department-name .typeahead')
        .typeahead(
          {
            highlight: true
          },
          {
            limit: 10,
            source: function(query, process) {
              var names = [];
              var map = {};
              var data = $('form').find('#search-department-name').data('department_names');

              $.each(data, function(i, dept) {
                map[dept.name] = dept;
                names.push(dept.name);
              });

              process(names);
            },
            matcher: function (target) {
              if (target.toLowerCase().indexOf(this.query.trim().toLowerCase()) != -1) {
                return true;
              }
            },
            sorter: function (departments) {
              return departments.sort();
            },
            highlighter: function (target) {
              var regex = new RegExp( '(' + this.query + ')', 'gi' );
              return target.replace( regex, "<strong>$1</strong>" );
            },
            updater: function (target) {
              selectedDept = map[target].id;
              return target;
            },
            templates: {
              suggestion: function(target) {
                return "<div>" + target + "</div>"
              }
            }
          })
        .bind('typeahead:select', function(ev, suggestion) {
          $('form').find('input[data-department_name="' + suggestion + '"]').prop('checked', true);
          $('form').find('input[name="child-department-id"]').trigger('change');

          $('#search-child-name').typeahead('destroy');
        });
    },

    updateChildList: function() {
      var list = $('form#new-child-record').find('.choose-child .children-list');
      var deptId = $('input[name="child-department-id"]:checked').val();
      var _this = this;

      $.ajax({
        url: '/illnesses/department_children',
        data: {department_id: deptId},
        type: 'GET',
        success: function(data) {
          var htmlSrc = $('#search-child-name-options-tmp').html();
          var template = Handlebars.compile(htmlSrc);
          var childrenOptionsHtml = template({children: data});

          list.html(childrenOptionsHtml);
          $.material.init();
          $('#search-child-name .typeahead')
            .typeahead(
              {
                highlight: true
              },
              {
                limit: 10,
                source: function(query, process) {
                  var names = [];
                  var map = {};

                  $.each(data, function(i, child) {
                    map[child.name] = child;
                    names.push(child.name);
                  });

                  process(names);
                },
                matcher: function (target) {
                  if (target.toLowerCase().indexOf(this.query.trim().toLowerCase()) != -1) {
                    return true;
                  }
                },
                sorter: function (children) {
                  return children.sort();
                },
                highlighter: function (target) {
                  var regex = new RegExp( '(' + this.query + ')', 'gi' );
                  return target.replace( regex, "<strong>$1</strong>" );
                },
                updater: function (target) {
                  selectedChild = map[target].id;
                  return target;
                },
                templates: {
                  suggestion: function(target) {
                    return "<div 'data-id'='" + '' + "'>" + target + "</div>"
                  }
                }
              })
            .bind('typeahead:select', function(ev, suggestion) {
              $('form').find('input[data-child_name="' + suggestion + '"]').prop('checked', true);
              $('form').find('input[name="child-id"]').trigger('change');
            });
        },
        error: function() {
          console.log('error');
        }

      })
    },

    fetchChildData: function() {
      var childId = $(this).val();

      $.ajax({
        url: '/illnesses/child_profile',
        data: {child_id: childId},
        type: 'GET',
        success: function(html) {
          $('form').find('.child-profile').html(html);
          $.material.init();
        }
      });
    },

    determineIllness: function() {
      var illnessKnown = $(this).val();

      $('form').find('.illness-detail').hide();
      $('form').find('#illness-known-' + illnessKnown).show();
    },

    determineSymptoms: function() {
      var illnessCode = $(this).val();

      if (illnessCode.length > 0) {
        $.ajax({
          url: '/illnesses/symptoms',
          data: {illness_code: illnessCode},
          type: 'GET',
          success: function(html) {
            $('form').find('#symptoms').html(html);
          }
        })
      }
    },

    showContactParentsDetails: function() {
      var contactParents = $(this).val();

      $('form').find('.contact-parent').hide();
      $('form').find('#contact-parent-' + contactParents).show();
    },

    showContactDoctorsDetails: function() {
      var contactDoctors = $(this).val();

      $('form').find('.contact-doctor').hide();
      $('form').find('#contact-doctor-' + contactDoctors).show();
    },

    fetchDepartmentWorkers: function() {
      var deptId = $(this).val();

      $.ajax({
        url: '/illnesses/department_workers',
        data: {department_id: deptId},
        type: 'GET',
        success: function(html) {
          $('form').find('.worker-names').html(html);
        }
      });
    },

    fetchWorkerData: function() {
      var workerId = $(this).val();

      if (workerId.length > 0) {
        $.ajax({
          url: '/illnesses/worker_profile',
          data: {worker_id: workerId},
          type: 'GET',
          success: function(html) {
            $('form').find('.worker-profile').html(html);
          }
        });
      }
    }

  });

  $(document).ready(function() {

    Illnesses.initSearchDepartment();

    $('#new-child-record').steps({
      headerTag: "label",
      bodyTag: "section",
      transitionEffect: "slideLeft",
      stepsOrientation: "vertical",
      labels: {
        finish: 'Submit'
      },
      onFinished: function() {
        $('form').trigger('submit');
      }
    });

    $('form#new-child-record')
      .on('change', 'input[name="child-department-id"]', Illnesses.updateChildList)
      .on('change', 'input[name="child-id"]', Illnesses.fetchChildData)
      .on('change', 'input[name="illness-known"]', Illnesses.determineIllness)
      .on('change', 'select[name="illness-list"]', Illnesses.determineSymptoms)
      .on('change', 'input[name="contact-parents"]', Illnesses.showContactParentsDetails)
      .on('change', 'input[name="contact-doctors"]', Illnesses.showContactDoctorsDetails)
      .on('change', 'select[name="worker-department"]', Illnesses.fetchDepartmentWorkers)
      .on('change', 'select[name="worker-id"]', Illnesses.fetchWorkerData);

  })
}(jQuery);
