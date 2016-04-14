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
    }
}