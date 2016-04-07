module ApplicationHelper

    def custom_link_to_remove_fields name, f
        f.hidden_field(:_destroy) + __link_to_function(name, "remove_fields(this)")
    end
  
    def custom_link_to_add_fields name, f, association
        new_object = f.object.class.reflect_on_association(association).klass.new
        fields = f.fields_for(association, new_object, :child_index => "new_#{association}") do |builder|
            render(association.to_s.singularize + "_fields", :f => builder)
        end
        __link_to_function(name, "add_fields(this, \"#{association}\", \"#{escape_javascript(fields)}\")")
    end

    private

    def __link_to_function name, on_click_event, opts={}
        link_to(name, 'javascript:void(0);', opts.merge(onclick: on_click_event))
    end
end
