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
    }
}