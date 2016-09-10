require 'rails_helper'

describe MessageNotificationJob do

  describe '#perform' do
    before { @admin = create(:admin_user) }
    before { @daycare_ABC= create(:daycare) }
    before { @department_ABC = @daycare_ABC.departments.first }
    before { @manager_ABC = create(:user, department: @department_ABC) }
    before { create(:user_daycare, user: @manager_ABC, daycare: @daycare_ABC) }

    before { @daycare_XYZ= create(:daycare) }
    before { @department_XYZ = @daycare_XYZ.departments.first }
    before { @manager_XYZ = create(:user, department: @department_XYZ) }
    before { create(:user_daycare, user: @manager_XYZ, daycare: @daycare_XYZ) }

    context 'when message sender is a Daycare Manager ' do
      context 'and when message is for workers only, ' do
        it 'should only send notifs to the workers under the daycare' do
          dc_worker = create(:worker_user, department: @department_ABC)
          create(:user_daycare, user: dc_worker, daycare: @daycare_ABC)

          message_template = create(:message_template_for_workers)
          message = create(:mngr_message_for_workers, message_template: message_template, owner: @manager_ABC)

          MessageNotificationJob.perform_now(message)
          expect( dc_worker.notifications.size ).to eql(1)
        end

        it 'should not send notifs to the workers outside the daycare' do
          dc_worker = create(:worker_user, department: @department_XYZ)
          create(:user_daycare, user: dc_worker, daycare: @daycare_XYZ)

          message_template = create(:message_template_for_workers)
          message = create(:mngr_message_for_workers, message_template: message_template, owner: @manager_ABC)

          MessageNotificationJob.perform_now(message)
          expect( dc_worker.notifications.size ).to eql(0)
        end
      end

      context 'and when message is for parents only, ' do
        it 'should only send notifs to parents with children under the daycare' do
          dc_parent = create(:parentee_user, department: @department_ABC)
          create(:user_daycare, user: dc_parent, daycare: @daycare_ABC)

          message_template = create(:message_template_for_parents)
          message = create(:mngr_message_for_parents, message_template: message_template, owner: @manager_ABC)

          MessageNotificationJob.perform_now(message)
          expect( dc_parent.notifications.size ).to eql(1)
        end

        it 'should not send notifs to other parents without children in the daycare' do
          dc_parent = create(:parentee_user, department: @department_XYZ)
          create(:user_daycare, user: dc_parent, daycare: @daycare_XYZ)

          message_template = create(:message_template_for_parents)
          message = create(:mngr_message_for_parents, message_template: message_template, owner: @manager_ABC)

          MessageNotificationJob.perform_now(message)
          expect( dc_parent.notifications.size ).to eql(0)
        end
      end
    end

    context 'when message sender is an Admin ' do
      context 'and when message is for workers only, ' do
        it 'should send notifs to all users with worker role' do
          message = create(:admin_message_for_workers, owner: @admin)

          worker_ABC = create(:worker_user, department: @department_ABC)
          create(:user_daycare, user: worker_ABC, daycare: @daycare_ABC)

          worker_XYZ = create(:worker_user, department: @department_XYZ)
          create(:user_daycare, user: worker_XYZ, daycare: @daycare_XYZ)

          MessageNotificationJob.perform_now(message)

          expect( worker_ABC.notifications.size ).to eql(1)
          expect( worker_XYZ.notifications.size ).to eql(1)
        end

        it 'should not send notifs to user who are not workers' do
          message = create(:admin_message_for_workers, owner: @admin)

          parent_ABC = create(:parentee_user, department: @department_ABC)
          create(:user_daycare, user: parent_ABC, daycare: @daycare_ABC)

          parent_XYZ = create(:parentee_user, department: @department_XYZ)
          create(:user_daycare, user: parent_XYZ, daycare: @daycare_XYZ)

          MessageNotificationJob.perform_now(message)

          expect( parent_ABC.notifications.size ).to eql(0)
          expect( parent_XYZ.notifications.size ).to eql(0)
        end
      end

      context 'and when message is for parents only, ' do
        it 'should only send notifs to all users with parentee role' do
          message = create(:admin_message_for_parents, owner: @admin)

          parent_ABC = create(:parentee_user, department: @department_ABC)
          create(:user_daycare, user: parent_ABC, daycare: @daycare_ABC)

          parent_XYZ = create(:parentee_user, department: @department_XYZ)
          create(:user_daycare, user: parent_XYZ, daycare: @daycare_XYZ)

          MessageNotificationJob.perform_now(message)

          expect( parent_ABC.notifications.size ).to eql(1)
          expect( parent_XYZ.notifications.size ).to eql(1)
        end

        it 'should not send notifs to user who are not parentees' do
          message = create(:admin_message_for_parents, owner: @admin)

          worker_ABC = create(:worker_user, department: @department_ABC)
          create(:user_daycare, user: worker_ABC, daycare: @daycare_ABC)

          worker_XYZ = create(:worker_user, department: @department_XYZ)
          create(:user_daycare, user: worker_XYZ, daycare: @daycare_XYZ)

          MessageNotificationJob.perform_now(message)

          expect( worker_ABC.notifications.size ).to eql(0)
          expect( worker_XYZ.notifications.size ).to eql(0)
        end
      end

      context 'and when message is for managers only, ' do
        it 'should only send notifs to all users with manager role' do
          message = create(:admin_message_for_managers, owner: @admin)

          MessageNotificationJob.perform_now(message)

          expect( @manager_ABC.notifications.size ).to eql(1)
          expect( @manager_XYZ.notifications.size ).to eql(1)
        end

        it 'should not send notifs to user who are not managers' do
          message = create(:admin_message_for_managers, owner: @admin)

          parent_ABC = create(:parentee_user, department: @department_ABC)
          create(:user_daycare, user: parent_ABC, daycare: @daycare_ABC)

          parent_XYZ = create(:parentee_user, department: @department_XYZ)
          create(:user_daycare, user: parent_XYZ, daycare: @daycare_XYZ)

          MessageNotificationJob.perform_now(message)

          expect( parent_ABC.notifications.size ).to eql(0)
          expect( parent_XYZ.notifications.size ).to eql(0)
        end
      end

      context 'when message is intended for more than 1 role, ' do
        it 'should send notifs to all uses with the specified role' do
          message = create(:message, owner: @admin)

          parent_ABC = create(:parentee_user, department: @department_ABC)
          create(:user_daycare, user: parent_ABC, daycare: @daycare_ABC)

          worker_XYZ = create(:worker_user, department: @department_XYZ)
          create(:user_daycare, user: worker_XYZ, daycare: @daycare_XYZ)

          MessageNotificationJob.perform_now(message)

          expect( parent_ABC.notifications.size ).to eql(1)
          expect( worker_XYZ.notifications.size ).to eql(1)
          expect( @manager_ABC.notifications.size ).to eql(0)
        end
      end

    end


  end
end
