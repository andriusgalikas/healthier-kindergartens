class PagesController < ApplicationController
    before_action :authenticate_user!, only: [:welcome, :infection, :instruction]

    def welcome

    end

    def instruction

    end

    def infection

    end

    def getting_started

        render layout: 'login'
    end    
end