module MessagesHelper
  def options_for_sub_subject_select
    @subjects.map(&:sub_subjects)
      .flatten
      .map{|sub| [sub.title, sub.id, {'data-parent_id': sub.parent_subject_id}]}
  end

  def edit_template_header
    t('messags.breadcrumb.edit_template') + ' :'
  end

  def choose_template_header
    "#{t('messages.breadcrumb.message')} > " +
      "#{t('messages.breadcrumb.choose_template')} :"
  end

  def add_subject_header
    "#{t('messages.breadcrumb.message')} > " +
      "#{t('messages.breadcrumb.create_template')} > " +
      "#{t('messages.breadcrumb.create_subject')} :"
  end

  def add_sub_subject_header
    "#{t('messages.breadcrumb.message')} > " +
      "#{t('messages.breadcrumb.create_template')} > " +
      "#{t('messages.breadcrumb.create_subject')} > " +
      "#{t('messages.breadcrumb.create_sub_subject')} :"
  end

  def add_recipient_header
    "#{t('messages.breadcrumb.message')} > " +
      "#{t('messages.breadcrumb.create_template')} > " +
      "#{t('messages.breadcrumb.create_subject')} > " +
      "#{t('messages.breadcrumb.create_sub_subject')} > " +
      "#{t('messages.breadcrumb.choose_recipient')} :"
  end

  def add_template_content_header
    "#{t('messages.breadcrumb.message')} > ... > " +
      "#{t('messages.breadcrumb.choose_recipient')} > " +
      "#{t('messages.breadcrumb.add_content')} :"
  end

  def choose_recipient_header
    "#{t('messages.breadcrumb.message_options')} > " +
      "#{t('messages.breadcrumb.choose_recipient')} : "
  end

  def choose_subject_header
    "#{t('messages.breadcrumb.message_options')} > " +
      "#{t('messages.breadcrumb.choose_recipient')} > " +
      "#{t('messages.breadcrumb.choose_subject')} : "
  end

  def choose_sub_subject_header
    "#{t('messages.breadcrumb.message_options')} > " +
      "#{t('messages.breadcrumb.choose_recipient')} > " +
      "#{t('messages.breadcrumb.choose_subject')} > " +
      "#{t('messages.breadcrumb.choose_sub_subject')} : "
  end

  def create_message_from_template_header
    "#{t('messages.breadcrumb.choose_recipient')} > " +
      "#{t('messages.breadcrumb.choose_subject')} > " +
      "#{t('messages.breadcrumb.choose_sub_subject')} > " +
      "#{t('messages.breadcrumb.send')} :"
  end

  def yield_js_translations
    trans = {}
    trans['no_template_for_role'] = I18n.t('messages.no_template_for_role')

    trans
  end

  def progress_bar_step(page_step, form_step)
    page_step > form_step ? 'complete' : page_step == form_step ? 'active' : 'disabled'
  end

end
