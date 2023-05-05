class Api::V1::ReferralSummaryController < Api::V1::ApiController
  def index
    summary = query.limit(params[:limit]).offset(params[:offset])
    
    render json: summary, except: [:id]
  end

  def create
    @guest = Guest.find_by(email: params[:guest_email], event_id: params[:event_id])
    referral = GuestReferral.find_by(guest_id: @guest.id, event: params[:event_id], email: params[:referee])

    if referral.update(:reward_type => params[:reward_type])
      head :ok
    else
      render json: referral.errors(), status: :unprocessable_entity
    end
    
    if referral.update(:reward_input => params[:reward].to_i)
      puts "Updated"
      head :ok
    else
      render json: referral.errors(), status: :unprocessable_entity
    end
    
    if(params[:reward_type] == "reward/ticket")
      if referral.update(:reward => referral.counted*params[:reward].to_i)
        head :ok
      else
        render json: referral.errors(), status: :unprocessable_entity
      end
    else
      if referral.update(:reward => referral.cost*params[:reward].to_i/100)
        head :ok
      else
        render json: referral.errors(), status: :unprocessable_entity
      end 
    end
  end

  private

  def query
    Guest.joins(:guest_referrals)
         .select("guests.email, guests.first_name, guests.last_name, guest_referrals.email as referred_email, guest_referrals.status as status, guest_referrals.counted as tickets, guest_referrals.cost as amount, guest_referrals.reward_type as reward_type, guest_referrals.reward_input as input, guest_referrals.reward as Rewards")
         .where("event_id = :event_id", {event_id: params[:event_id]})
  end
end
