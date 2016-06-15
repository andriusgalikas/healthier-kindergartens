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

    # Creates a JavaScript tag, targeting the associated JavaScript file within the asset pipeline
    # This method is used for page specific JavaScript files
    #
    # @overload set(value)
    #   @param [String] javascript file name
    # @return [String] javascript tags
    def javascript location, *files
        content_for(location) { javascript_include_tag(*files) }
    end

    # Create a new object to start building breadcrumbs for the administration area
    #
    # @return [Object] breadcrumbs for the current page in the administration area
    def create_admin_breadcrumbs
        @admin_breadcrumbs ||= [ { :title => 'Healthier Childcare', :url => admin_root_path}]
    end

    # Add a new breadcrumb to the administration area breadcrumb object using the parameters
    #
    # @param title [String]
    # @param url [String]
    def breadcrumb_add title, url
        create_admin_breadcrumbs << { :title => title, :url => url }
    end

    # Renders the HTML elements for the breadcrumbs
    #
    # @param type [Integer]
    # @return [String] HTML elements
    def render_breadcrumbs type
        if type == 0
            render partial: 'shared/admin/breadcrumbs', locals: { breadcrumbs: create_admin_breadcrumbs }
        else
            render partial: theme_presenter.page_template_path('shared/admin/breadcrumbs'), locals: { breadcrumbs: create_store_breadcrumbs }
        end
    end

    # If the string parameter equals the current controller value in the parameters hash, return a string
    #
    # @param controller [String]
    # @param action [String]
    # @return [String] class name for a HTML element
    def active_controller? data
        if data[:action].nil?
            "current" if params[:controller] == data[:controller]
        else
            "current" if params[:controller] == data[:controller] && params[:action] == data[:action]
        end
    end

    def yield_js_translations
      trans = {};
      trans['featured_daycare'] = I18n.t('notifications.featured_daycare')
      trans['featured_daycare_by_plan'] = I18n.t('notifications.featured_daycare_by_plan')
      trans['no_template_for_role'] = I18b.t('admin.no_template_for_role')
      trans
    end

  def current_user_role_avatar
    if current_user.manager?
      'manager.png'
    elsif current_user.parentee?
      'parent.png'
    elsif current_user.worker?
      'worker.png'
    elsif current_user.partner?
      current_user.affiliate.profile_image.file.url
    elsif role == 'admin'
      'super-admin.png'
    else
      'logo_menu.png'
    end
  end

    private

    def __custom_link_to_function name, on_click_event, button_color, opts={}
        link_to(name, 'javascript:void(0);', opts.merge(onclick: on_click_event, class: "btn btn-#{button_color} btn-normal"))
    end
end
