class ProposalsController < ApplicationController
    before_action :authenticate_user!, only: [:new]
    before_action :find_ad, only: [:create, :new, :show]

    def show
        @proposal = Proposal.find(params[:id])
    end

    def new
      @proposal = @ad.proposals.new
    end

    def create
        @proposal = @ad.proposals.new(proposal_params)
        @proposal.user = current_user
        if @proposal.save
            redirect_to @ad
        else
            flash[:error] = 'Houve um erro'
            render :new
        end

    end

    def my_proposals
      @proposals = current_user.my_proposals.where(status: :pending)
    end

    def approve
      @proposal = Proposal.find(params[:id])
      @proposal.status = :approved
      @proposal.save
      flash[:notice] = 'Proposta aceita com sucesso.'
      redirect_to my_proposals_path
    end

    def reject
      @proposal = Proposal.find(params[:id])
      @proposal.status = :rejected
      @proposal.save
      flash[:notice] = 'Proposta recusada com sucesso.'
      redirect_to my_proposals_path
    end


    private
    def find_ad
      @ad = Ad.find(params[:ad_id])
    end

  def proposal_params
    params.require(:proposal).permit(:description, :requested_knowledge, :email, :day_period, :meeting_type)
  end
end
