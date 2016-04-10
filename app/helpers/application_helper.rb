module ApplicationHelper

    def custom_link_to_remove_fields name, f
        f.hidden_field(:_destroy) + __custom_link_to_function(name, "remove_fields(this)", 'red')
    end
  
    def custom_link_to_add_fields name, f, association
        new_object = f.object.class.reflect_on_association(association).klass.new
        new_object.build_profile_image if association == :children
        fields = f.fields_for(association, new_object, :child_index => "new_#{association}") do |builder|
            render(association.to_s.singularize + "_fields", :f => builder)
        end
        __custom_link_to_function(name, "add_fields(this, \"#{association}\", \"#{escape_javascript(fields)}\")", 'green')
    end

    private

    def __custom_link_to_function name, on_click_event, button_color, opts={}
        link_to(name, 'javascript:void(0);', opts.merge(onclick: on_click_event, class: "btn btn-#{button_color} btn-normal"))
    end
end
