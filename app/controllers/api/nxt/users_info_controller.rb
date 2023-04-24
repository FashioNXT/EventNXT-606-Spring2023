# Amith - Amin 2023-04-21


class Api::Nxt::UsersInfoController < ActionController::API
    before_action :authenticate_server
    
    def index
        users = User.all
        user_info = users.map do |user|
            access_enabled = !user.deactivated
            app = "EventNXT"
            average_minutes_used_last_30_days = "null"
            user_type = user.is_admin ? "Admin": "User"
            initial_access = user.created_at.strftime("%Y-%m-%d")
            last_access = "null"
            updated_at = user.updated_at.strftime("%Y-%m-%d")
            {
                access_enabled: access_enabled,
                app: app,
                average_minutes_used_last_30_days: average_minutes_used_last_30_days,
                created_at: initial_access,
                user_type: user_type,
                initial_access: initial_access,
                last_access: last_access,
                updated_at: updated_at
            }
        end

        render json: { user_info: user_info }
    end
        
        
    private
    
    def authenticate_server
    end
end
