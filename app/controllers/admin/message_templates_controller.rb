class Admin::MessageTemplatesController < AdminController
  layout 'dashboard_v2'

  def create
    set_subject
    set_sub_subject
    @template = @sub_subject.message_templates
                .build(message_template_params.merge(sub_subject_id: @sub_subject.id))

    if @template.save
      redirect_to admin_message_templates_path, notice: t('messages.notifications.create_template_success')
    else
      redirect_to new_admin_message_template_path, notice: t('messages.notifications.create_template_error')
    end
  end

  def new
    @template = MessageTemplate.new
  end

  def edit_filters
    get_all_main_subjects
  end

  def show
    set_message_template
  end

  def edit
    set_message_template
  end

  def update
    set_message_template

    if @template.update(message_template_params)
      redirect_to admin_message_template_path(@template), notice: t('messages.notifications.update_template_success')
    else
      render :edit
    end
  end

  def destroy
    set_message_template
    @template.deactivate!

    redirect_to admin_message_templates_path, notice: t('messages.notifications.delete_template_success')
  end

  def filter
    find_template_by_filters

    if @template.present?
      redirect_to admin_message_template_path(@template)
    else
      redirect_to edit_filters_admin_message_templates_path, notice: t('messages.notifications.find_template_empty')
    end

  end

  private

  def set_subject
    @subject = MessageSubject.create(title: params[:subject_title])
  end

  def set_sub_subject
    @sub_subject = @subject.sub_subjects.create(title: params[:sub_subject_title])
  end

  def set_message_template
    @template = MessageTemplate.find params[:id]
  end

  def message_template_params
    params.require(:message_template).permit(
      :target_role,
      :language,
      :content
    )
  end

  def get_all_main_subjects
    @subjects = MessageSubject.main_subjects
  end

  def find_template_by_filters
    @subject = MessageSubject.find(params[:subject_id]) if params[:subject_id].present?
    @sub_subject = @subject.sub_subjects.find(params[:sub_subject_id]) if @subject && params[:sub_subject_id].present?

    @template = @sub_subject.message_templates.active.for_role(params[:target_role]) if @sub_subject && params[:target_role]
  end

end
