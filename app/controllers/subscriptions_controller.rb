class SubscriptionsController < ApplicationController
    before_action -> { authenticate_role!(["manager"]) }
    before_action :unsubscribed_user!, except: :complete

    def index
        set_plans
        set_range_data
        @plan1=Plan.find_by_allocation(30)
        @plan2=Plan.find_by_allocation(60)
        @plan3=Plan.find_by_allocation(90)
    end

    def new
        set_plan
        new_subscription
    end

    def create
        set_plan
        @subscription = @plan.subscriptions.build(subscription_params)
        set_discount_code
        if @subscription.save_with_payment(@discount_code)
            PlanMailer.send_confirmation(current_user).deliver_later
            redirect_to complete_plan_subscription_url(@subscription.plan, @subscription), :notice => "Thank you for subscribing!"
        else
            render :new
        end
    end

    def complete
        set_subscription
        validate_user_subscription
    end

    private

    def subscription_params
        params.require(:subscription).permit(:user_id, :plan_id, :terms, :stripe_card_token, :discount_code).merge(user_id: current_user.id)
    end

    def set_plan
        @plan ||= Plan.find(params[:plan_id])
    end

    def set_subscription
        @subscription ||= Subscription.find(params[:id])
    end

    def new_subscription
        @subscription = @plan.subscriptions.build
    end

    def set_plans
        @plans ||= Plan.all
    end

    def set_range_data
       @range ||= {
            min: @plans.first.allocation,
            max: @plans.last.allocation,
            step: @plans.last.allocation/@plans.count
        }
    end

    def unsubscribed_user!
        unless current_user && current_user.unsubscribed?
            redirect_to dashboard_url, alert: "You already have a subscription associated with your account"
        end
    end

    def validate_user_subscription
        unless current_user.subscription == @subscription
            redirect_to dashboard_url, alert: 'You do not have access to this resource'
        end
    end

    def set_discount_code
        @discount_code = DiscountCode.active.find_by_code(params[:discount_code])
    end
end