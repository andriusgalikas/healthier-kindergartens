class SubscriptionsController < ApplicationController
    before_action :authenticate_user!
    before_action :unsubscribed_user!, except: :complete

    def index
        set_plans
    end

    def new
        set_plan
        new_subscription
    end

    def create
        binding.pry
        @subscription = Subscription.new(subscription_params)
        set_discount_code
        if @subscription.save_with_payment(@discount_code)
            redirect_to complete_plan_subscription_url(@subscription.plan, @subscription), :notice => "Thank you for subscribing!"
        else
            render :new
        end
    end

    def complete
        set_plan
        set_subscription
        validate_user_subscription
    end

    private

    def subscription_params
        params.require(:subscription).permit(:plan_id, :user_id, :stripe_card_token, :discount_code)
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

    def unsubscribed_user!
        unless current_user && current_user.unsubscribed?
            redirect_to root_url(subdomain: false), alert: "You already have a subscription associated with your account"
        end
    end

    def validate_user_subscription
        unless current_user.subscription == @subscription
            redirect_to root_url(subdomain: false), notice: 'You do not have access to this resource'
        end
    end

    def set_discount_code
        @discount_code = DiscountCode.active.find_by_code(params[:discount_code])
    end
end