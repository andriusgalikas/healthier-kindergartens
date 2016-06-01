healthChildcare.app =
{
    departmentSelector: function()
    {
        $('.department-populater').change(function()
        {
            var selectedDaycareId = $('.department-populater option:selected').val(),
                $select = $('.department-select');
            $.ajax(
            {
                url: '/api/daycares/' + selectedDaycareId + '/departments',
                type: 'GET',
                dataType: 'json',
                success: function (data)
                {
                    $select.find('option').remove();
                    $.each(data.departments, function(key, value) {
                        $select.append('<option value=' + value["id"] + '>' + value["name"] + '</option>');
                    });
                }
            });
        });
    },

    multiInput: function()
    {
        $('.tagsinput').tagsinput();
    },

    toggleMenu: function()
    {
        $('.dropdown').click(function()
        {
            $(this).toggleClass('open');
        });
    },

    printTodo: function()
    {
        $('#print-todo').on('click', function()
        {
            window.print();
            return false;
        });
    },

    datepickers: function()
    {
        $('.datepicker').datetimepicker({
            formatDate: 'd-m-Y',
            formatTime: '',
            theme:'default',
            timepicker: false
        });

        $('.datetimepicker').datetimepicker({
            formatDate: 'd-m-Y',
            theme:'default'
        });
    },

    submitSurveyModule: function()
    {
        $("body").on("submit", '.submit-attempt', function()
        {
            var tabId = $(this).attr('data-tab');
            $.ajax(
            {
                url: $(this).attr('action'),
                type: 'POST',
                data: $(this).serialize(),
                dataType: 'json',
                success: function (data)
                {
                    click_tab(tabId);
                }
            });
            return false;
        });
    },

  showRegisteredChildcaresNotification: function() {
    var beforeSignUpPath = /getting_started/g;
    var afterSignUpPath = /welcome/g;
    var newUser = $('input#notif_new_user').val() == 'true';
    var showNotif = beforeSignUpPath.test(window.location.pathname) ||
        (afterSignUpPath.test(window.location.pathname) && newUser);
    var featuredDaycare = [];

    if (showNotif) {
      function fetchFeaturedDaycare() {
        $.ajax(
          {
            url: '/api/daycares/featured_daycare',
            type: 'GET',
            dataType: 'json',
            success: function (data)
            {
              if ($.inArray(data.name, featuredDaycare) < 0 ) {
                featuredDaycare.push(data.name);
                $.notify({
                  icon: "/assets/back_page.png",
                  message: data.name + " " + window.__trans['featured_daycare']
                })
              }
              else if (featuredDaycare.length == data.set_size)
                clearInterval(occasionalFetch);
            }
          })
      }

      occasionalFetch = setInterval(fetchFeaturedDaycare, 5000);
    }
  },

  showUpgradedChildcaresNotification: function() {
    var newPlan = $('input#notif_plan_id').val() || '';
    var featuredDaycare = [];

    if (newPlan != '') {
      function fetchSimilarPlans() {
        $.ajax(
          {
            url: '/api/daycares/by_plan?plan_id=' + newPlan,
            type: 'GET',
            dataType: 'json',
            success: function (data)
            {
              if ($.inArray(data.name, featuredDaycare) < 0 ) {
                featuredDaycare.push(data.name);
                $.notify({
                  icon: '/assets/back_page.png',
                  message: data.name + " " + window.__trans['featured_daycare_by_plan']
                })
              }
              else if (featuredDaycare.length == data.set_size)
                clearInterval(occasionalFetch);
            }
          })
      }

      occasionalFetch = setInterval(fetchSimilarPlans, 5000);
    }
  }

}
