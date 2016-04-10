# == Schema Information
#
# Table name: todos
#
#  id             :integer          not null, primary key
#  title          :string
#  iteration_type :integer          default("0")
#  frequency      :integer          default("0")
#  daycare_id     :integer
#  user_id        :integer
#  created_at     :datetime         not null
#  updated_at     :datetime         not null
#

class Todo < ActiveRecord::Base
    has_many :tasks,                                                            class_name: 'TodoTask', dependent: :destroy
    has_many :tasks_complete,                                                   through: :tasks

    has_many :todo_completes,                                                   dependent: :destroy

    has_many :department_todos
    has_many :departments,                                                      through: :department_todos, dependent: :destroy

    has_many :user_occurrences,                                                 dependent: :destroy
    has_many :active_user_occurrences,                                          -> { where(status: 0) }, class_name: 'UserOccurrence'
    has_many :inactive_users,                                                   through: :active_user_occurrences, source: :user

    has_one :icon,                                                              -> { where(attachable_type: 'TodoIcon') }, class_name: 'Attachment', foreign_key: 'attachable_id', dependent: :destroy

    belongs_to :daycare
    belongs_to :user

    scope :complete,                                                            -> { includes(:todo_completes).where.not(todo_completes: { completion_date: nil } ) }
    scope :incomplete,                                                          -> { includes(:todo_completes).where.not(todo_completes: { id: nil } ).where(todo_completes: { completion_date: nil } )  }                                        
    scope :available,                                                           -> { includes(:todo_completes).where(todo_completes: { id: nil } ) }
    scope :global,                                                              -> { where(daycare_id: nil) }

    scope :search,                                              ->(query, ids, page, per_page_count, limit_count) { where(id: ids).where("title LIKE :search", search: "%#{query}%").limit(limit_count).page(page).per(per_page_count) }

    delegate :complete, :incomplete, :available,                                to: [:daycare, :department]

    validates :title, :frequency, :user_id,                                     presence: true
    validates :iteration_type,                                                  presence: true, :if => :recurring?

    validates :icon,                                                            presence: true

    enum iteration_type: [:single, :recurring]
    enum frequency: [:day, :week, :month, :year]

    accepts_nested_attributes_for :tasks, :icon, allow_destroy: true

    def global?
        daycare_id.nil? ? true : false
    end

    def frequency_to_time
        day? ? 1.days.ago.to_date : week? ? 7.days.ago.to_date : month? ? 1.month.ago.to_date : 1.year.ago.to_date 
    end

    def in_progress? current_user_id
        todo_completes.active.map(&:submitter_id).include?(current_user_id) ? true : false
    end
end
