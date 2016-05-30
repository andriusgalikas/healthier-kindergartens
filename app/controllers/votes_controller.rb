class VotesController < ApplicationController
  before_action :authenticate_user!

  def cast_vote
    Vote.create(vote_candidate_code: params['vote_candidate_code'], voter: current_user)

    redirect_to :back
  end

end
