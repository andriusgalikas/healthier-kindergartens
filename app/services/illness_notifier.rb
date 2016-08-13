class IllnessNotifier

=begin
  subject      : Child
  illness      : HealthRecordComponent code: 'illness_code'
  message      : HealthRecordComponent code: 'contact_parent_code'
  target       : User(parent, partner)
  recorder     : User
=end
  def initialize(opts)
    @subject = opts[:subject]
    @illness = opts[:illness]
    @message = opts[:message]
    @recorder = opts[:recorder]

    @discussion = nil
  end

  def notify_parents!
    start_health_conversation
    send_email_notif
  end

  private

  def start_health_conversation
    @discussion = Discussion.create(subject: @subject, title: "#{@subject.name} : #{@illness}", owner: @recorder)
    @discussion.comments.create(content: @message, owner: @recorder)
    @discussion.discussion_participants.create(participant: @subject.department, initiator: true)
    @discussion.discussion_participants.create(participant: @subject.parentee)
  end

  def send_email_notif
    HealthConversationNotificationJob.perform_now(@discussion, sender: @recorder.department)
  end

end
