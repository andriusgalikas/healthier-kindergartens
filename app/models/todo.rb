# == Schema Information
#
# Table name: todos
#
#  id                    :integer          not null, primary key
#  title                 :string
#  iteration_type        :integer          default("0")
#  frequency             :integer          default("0")
#  daycare_id            :integer
#  user_id               :integer
#  created_at            :datetime         not null
#  updated_at            :datetime         not null
#  completion_date_type  :integer          default("0")
#  completion_date_value :integer          default("1")
#

class Todo < ActiveRecord::Base
    has_many :tasks,                                                            class_name: 'TodoTask', dependent: :destroy
    has_many :global_tasks,                                                     -> { where(task_type: 0) }, class_name: 'TodoTask'
    has_many :local_tasks,                                                      -> { where(task_type: 1) }, class_name: 'TodoTask'
    has_many :tasks_complete,                                                   through: :tasks

    has_many :todo_completes,                                                   dependent: :destroy

    has_many :department_todos
    has_many :departments,                                                      through: :department_todos, dependent: :destroy

    has_many :user_occurrences,                                                 dependent: :destroy
    has_many :active_user_occurrences,                                          -> { where(status: 0) }, class_name: 'UserOccurrence'
    has_many :inactive_users,                                                   through: :active_user_occurrences, source: :user

    has_many :user_destroys,                                                    class_name: 'UserTodoDestroy'

    has_one :icon,                                                              -> { where(attachable_type: 'TodoIcon') }, class_name: 'Attachment', foreign_key: 'attachable_id', dependent: :destroy

    belongs_to :daycare
    belongs_to :user

    scope :complete,                                                            -> { includes(:todo_completes).where.not(todo_completes: { completion_date: nil } ) }
    scope :incomplete,                                                          -> { includes(:todo_completes).where.not(todo_completes: { id: nil } ).where(todo_completes: { completion_date: nil } )  }
    scope :available,                                                           -> { includes(:todo_completes).where(todo_completes: { id: nil } ) }
    scope :global,                                                              -> { where(daycare_id: nil) }

    scope :search,                                              ->(query, ids, page, per_page_count, limit_count) { where(id: ids).where("title LIKE :search", search: "%#{query}%").limit(limit_count).page(page).per(per_page_count) }

    delegate :complete, :incomplete, :available,                                to: [:daycare, :department]

    validates :title, :user_id, :completion_date_type,
                :completion_date_value, :iteration_type,                        presence: true
    validates :frequency,                                                       presence: true, :if => :recurring?
    validates :icon,                                                            presence: true
    validates :title,                                                           uniqueness: { scope: :user_id }

    enum iteration_type:            [:single, :recurring]
    enum frequency:                 [:day, :week, :month, :year]
    enum completion_date_type:      [:completion_day, :completion_week, :completion_month, :completion_year, :completion_hour]

    before_save :set_frequency_for_single, :is_admin_global?
    before_destroy :is_admin_global?


    accepts_nested_attributes_for :tasks, :icon, allow_destroy: true

    # => Check if a todo is global (created by admin user)
    #
    def global?
        daycare_id.nil? ? true : false
    end

    # => Check if a todo is local (created by manager)
    #
    def local?
        daycare_id.nil? ? false : true
    end

    # => Convert the enum frequency attribute to a datetime format
    #
    def frequency_to_time
        day? ? 1.days.ago.to_date : week? ? 7.days.ago.to_date : month? ? 1.month.ago.to_date : 1.year.ago.to_date
    end

    # => Conver the completion_date_value and completion_date to a datetime format
    #
    def completion_date_to_time
        Chronic.parse("#{completion_date_value} #{completion_date} ago")
    end

    # => Check if a certain is currently in progress by the current_user_id parameter
    #
    def in_progress? current_user_id
        todo_completes.active.map(&:submitter_id).include?(current_user_id) ? true : false
    end

    # => If the iteration type of the todo is single, set the frequency to nil
    #
    def set_frequency_for_single
        self.frequency = nil if single?
    end

    # => Convert the completion_date_type to a user friendly string
    #
    def completion_date
        completion_date_type.split('_').last.titleize
    end

    # => Checks if user is admin or global if updating, saving or destroying a todo record
    #
    def is_admin_global?
        if global? && !user.admin?
            errors.add :base, "You do not have permission to save or destroy this Todo."
            return false
        end
    end
end
