class Admin::PermissionsController < AdminController
    skip_before_filter :verify_authenticity_token, :only => [:change]

    def option
    end

    def list
        @type_label = ''
        case params[:option]
        when '0'
            @type_label = "Certification Partnership"
        when '1'
            @type_label = "Healthier and Safer Childcare Partnership"
        when '2'
            @type_label = "Chain Daycare"
        when '3'
            @type_label = "Independant Daycare"
        when '4'
            @type_label = "Govermantal Daycare"
        end

        [0, 1, 2, 3, 4, 5, 6].each do |ix|
            permission = Permission.where(sub_type: params[:option].to_i, feature: ix)
            if permission.length == 0
                permission = Permission.find_or_create_by(sub_type: params[:option].to_i, feature: ix)
            end
        end

        @permissions = Permission.where(sub_type: params[:option].to_i).order(:feature);
    end

    def change
        initial_permissions

        params[:id].each_with_index do |item, ix|
            permission = Permission.find(item)            
            permission.active = (params["feature_#{permission.id}"].nil?) ? false : true
            permission.plan = params[:plan][ix] if params[:option].to_i > 1
            permission.save
        end
        
        redirect_to option_admin_permissions_path
    end

    private
        def initial_permissions
            @permissions = Permission.where(sub_type: params[:option].to_i);

            @permissions.each do |item|
                item.active = false
                item.save
            end
        end
end