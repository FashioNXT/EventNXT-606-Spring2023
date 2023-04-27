class Api::V1::ReferralSummaryController < Api::V1::ApiController
  def index
    summary = query.limit(params[:limit]).offset(params[:offset])
    reward = ReferralReward.find_by(event_id: params[:event_id])
    
    if reward
      summary[0]["Rewards"] = summary[0]["Rewards"].to_i + reward[:reward].to_i
    end
    render json: summary, except: [:id]
  end

  def create
    reward = ReferralReward.new(event_id: params[:event_id], reward: params[:reward])
    #event = Event.find(params[:event_id])
    if reward.save
      render json: reward.to_json, status: :created
    else
      reward = ReferralReward.find_by(event_id: params[:event_id])
      if reward.update(:reward => params[:reward])
        render json: reward.to_json, status: :ok
        #redirect_back(fallback_location: root_path)
      else
        render json: reward.errors, status: :unprocessable_entity
      end
    end
    
  end

  private

  def query
    Guest.joins(:guest_referrals)
         .select("guests.email, guests.first_name, guests.last_name, guest_referrals.email as referred_email, guest_referrals.counted as status, guest_referrals.counted as Rewards")
         .where("event_id = :event_id", {event_id: params[:event_id]})
  end
end
