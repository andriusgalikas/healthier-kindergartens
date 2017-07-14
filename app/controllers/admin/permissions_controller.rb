class Admin::PermissionsController < AdminController
    skip_before_filter :verify_authenticity_token, :only => [:change]

    def option
    end

    def group
        get_type_label
    end

    def list
        get_type_label
        get_group_label

        [0, 1, 2, 3, 4, 5, 6].each do |ix|
            permission = Permission.where(sub_type: params[:option].to_i, member_type: params[:group].to_i, feature: ix)
            if permission.length == 0
                permission = Permission.find_or_create_by(sub_type: params[:option].to_i, member_type: params[:group].to_i, feature: ix)
            end
        end

        @permissions = Permission.where(sub_type: params[:option].to_i, member_type: params[:group].to_i).order(:feature);
    end

    def change
        initial_permissions

        params[:id].each_with_index do |item, ix|
            permission = Permission.find(item)            
            permission.active       = (params["feature_#{permission.id}"].nil?) ? false : true
            permission.plan         = params[:plan][ix] if params[:option].to_i > 1

            result = get_permission_info(permission.member_type, permission.feature)

            permission.path         = result[:path]
            permission.guide_path   = result[:guide_path]
            permission.element      = result[:element]
            permission.image        = result[:image]
            permission.label_key    = result[:label_key]
            permission.save
        end
        
        redirect_to option_admin_permissions_path
    end

    private
        def initial_permissions
            @permissions = Permission.where(sub_type: params[:option].to_i, member_type: params[:group].to_i);

            @permissions.each do |item|
                item.active = false
                item.save
            end
        end

        def get_type_label
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
        end

        def get_group_label
            @group_label = ''
            case params[:group]
            when '0'
                @group_label = "Daycare Manager"
            when '1'
                @group_label = "Daycare Worker"
            when '2'
                @group_label = "Daycare Parent"
            when '3'
                @group_label = "Partner"
            end
        end

        def get_permission_info(member_type, feature)
            result = {
                path: '',
                guide_path: '',
                element: '',
                image: '',
                label_key: ''
            }
            case feature
            # Survey
            when 'survey'
                case member_type
                # manager
                when 'manager'
                    result[:path] = results_manager_subjects_path
                    result[:guide_path] = '/guide_page/manager_survey/result_step1'
                # worker
                when 'worker'
                    result[:path] = results_subjects_path
                    result[:guide_path] = '/guide_page/worker_survey/take_step1'
                # parent
                when 'parent'
                    result[:path] = results_subjects_path
                    result[:guide_path] = '#'
                # partner
                when 'partner'
                    result[:path] = '#'
                    result[:guide_path] = '#'
                end
                result[:element] = 'item_survey'
                result[:image] = 'dashboard-risk.png'
                result[:label_key] = 'dashboard.menu_item.risk_assessment'
            # online_training
            when 'online_training'
                result[:path] = instruction_path
                result[:guide_path] = instruction_path

                result[:element] = 'item_instruction'
                result[:image] = 'dashboard-instruction.png'
                result[:label_key] = 'dashboard.menu_item.instruction'
            # message
            when 'message'
                case member_type
                # manager
                when 'manager'
                    result[:path] = manager_messages_path
                    result[:guide_path] = '/guide_page/manager_message/dash'
                # worker
                when 'worker'
                    result[:path] = '#'
                    result[:guide_path] = '#'
                # parent
                when 'parent'
                    result[:path] = list_messages_path(role: current_user.role, list_type: 'received')
                    result[:guide_path] = '#'
                # partner
                when 'partner'
                    result[:path] = partner_messages_path
                    result[:guide_path] = '#'
                end

                result[:element] = 'item_message'
                result[:image] = 'dashboard-com-mng.png'
                result[:label_key] = 'dashboard.menu_item.communication'
            # todo
            when 'todo'
                case member_type
                # manager
                when 'manager'
                    result[:path] = dashboard_manager_todos_path
                    result[:guide_path] = '/guide_page/manager_todo/dash'
                # worker
                when 'worker'
                    result[:path] = todos_path
                    result[:guide_path] = '/guide_page/worker_todo/todo_step1'
                # parent
                when 'parent'
                    result[:path] = '#'
                    result[:guide_path] = '#'
                # partner
                when 'partner'
                    result[:path] = '#'
                    result[:guide_path] = '#'
                end

                result[:element] = 'item_todo'
                result[:image] = 'dashboard-taskmng.png'
                result[:label_key] = 'dashboard.menu_item.task_manager'
            # illness_analysics
            when 'illness_analysics'
                case member_type
                # manager
                when 'manager'
                    result[:path] = set_filters_manager_illnesses_path
                    result[:guide_path] = '/guide_page/manager_illness/graph_step1'
                # worker
                when 'worker'
                    result[:path] = '#'
                    result[:guide_path] = '#'
                # parent
                when 'parent'
                    result[:path] = '#'
                    result[:guide_path] = '#'
                # partner
                when 'partner'
                    result[:path] = '#'
                    result[:guide_path] = '#'
                end

                result[:element] = 'item_illness_graph'
                result[:image] = 'dashboard-illness-graph.png'
                result[:label_key] = 'dashboard.menu_item.illness_analytic'
            # illness_record
            when 'illness_record'
                case member_type
                # manager
                when 'manager'
                    result[:path] = filter_illnesses_path
                    result[:guide_path] = '/guide_page/worker_illness/view_dash'
                # worker
                when 'worker'
                    result[:path] = illnesses_path
                    result[:guide_path] = '/guide_page/worker_illness/view_dash'
                # parent
                when 'parent'
                    result[:path] = '#'
                    result[:guide_path] = '#'
                # partner
                when 'partner'
                    result[:path] = '#'
                    result[:guide_path] = '#'
                end

                result[:element] = 'item_illness'
                result[:image] = 'dashboard-ilness.png'
                result[:label_key] = 'dashboard.menu_item.illness_record'
            # illness_guide
            when 'illness_guide'
                case member_type
                # manager
                when 'manager'
                    result[:path] = role_manager_illness_guides_path
                    result[:guide_path] = '/guide_page/worker_illness/view_dash'
                # worker
                when 'worker'
                    result[:path] = role_worker_illness_guides_path
                    result[:guide_path] = '/guide_page/worker_illness/view_dash'
                # parent
                when 'parent'
                    result[:path] = role_parentee_illness_guides_path
                    result[:guide_path] = '#'
                # partner
                when 'partner'
                    result[:path] = '#'
                    result[:guide_path] = '#'
                end

                result[:element]    = 'item_illness_guide'
                result[:image]      = 'dashboard-ilness-rec.png'
                result[:label_key]  = 'dashboard.menu_item.illness_guide'
            end
            return result
        end
end