require 'rails_helper'

describe MessageNotificationJob do

  describe '#perform' do
    before { @daycare = create(:daycare) }
    before { @department = @daycare.departments.first }
    before { @dc_manager = create(:user, department: @department) }
    before { create(:user_daycare, user: @dc_manager, daycare: @daycare) }

    context 'when message sender is a Daycare Manager, ' do
      it 'should only send notifs to the workers under the daycare' do
        dc_worker = create(:worker_user, department: @department)
        create(:user_daycare, user: dc_worker, daycare: @daycare)

        message_template = create(:message_template_for_workers)
        message = create(:message_for_workers, message_template: message_template, owner: @dc_manager)

        MessageNotificationJob.perform_now(message)
        expect( dc_worker.notifications.size ).to eql(1)
      end

      it 'should not send notifs to the workers outside the daycare' do
        dummy_daycare = create(:daycare)
        dummy_dept = dummy_daycare.departments.first
        dummy_dc_worker = create(:worker_user, department: dummy_dept)

        message_template = create(:message_template_for_workers)
        message = create(:message_for_workers, message_template: message_template, owner: @dc_manager)

        MessageNotificationJob.perform_now(message)
        expect( dummy_dc_worker.notifications.size ).to eql(0)
      end

      it 'should only send notifs to parents with children under the daycare' do
        dc_parent = create(:parentee_user, department: @department)
        create(:user_daycare, user: dc_parent, daycare: @daycare)
        dc_parent.touch

        message_template = create(:message_template_for_parents)
        message = create(:message_for_parents, message_template: message_template, owner: @dc_manager)
        MessageNotificationJob.perform_now(message)
        expect( dc_parent.notifications.size ).to eql(1)
      end

      it 'should not send notifs to other parents without children in the daycare' do
        dummy_daycare = create(:daycare)
        dummy_dept = dummy_daycare.departments.first
        dummy_dc_parent = create(:parentee_user, department: dummy_dept)

        message_template = create(:message_template_for_parents)
        message = create(:message_for_parents, message_template: message_template, owner: @dc_manager)

        MessageNotificationJob.perform_now(message)
        expect( dummy_dc_parent.notifications.size ).to eql(0)
      end
    end

    context 'when message sender is an Admin, ' do
      context 'when message is for workers only, ' do
        it 'should only send notifs to all users with worker role' do
        end

        it 'should not send notifs to user who are not workers' do
        end
      end

      context 'when message is for parents only, ' do
        it 'should only send notifs to all users with parentee role' do
        end

        it 'should not send notifs to user who are not parentees' do
        end
      end

      context 'when message is for managers only, ' do
        it 'should only send notifs to all users with manager role' do
        end

        it 'should not send notifs to user who are not managers' do
        end
      end

      context 'when message is intended for more than 1 role, ' do
        it 'should send notifs to all uses with the specified role' do
        end
      end

    end


  end
end
