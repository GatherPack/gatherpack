require "omniauth-oauth2"

module OmniAuth
  module Strategies
    class GatherPack < OmniAuth::Strategies::OAuth2
      option :name, "gather_pack"

      option :client_options, {
        authorize_url: "/oauth/authorize",
        token_url: "/oauth/token"
      }

      option :authorize_options, [ :scope, :state ]
      option :scope, "user_read user_email user_name teams_read badges_read"

      uid { raw_info["sub"] }

      info do
        {
          email: raw_info["email"],
          first_name: raw_info["given_name"],
          last_name: raw_info["family_name"],
          name: raw_info["name"],
          nickname: raw_info["preferred_username"],
          image: raw_info["picture"],
          urls: { profile: raw_info["profile"] }
        }
      end

      extra do
        {
          raw_info: raw_info,
          teams: raw_info["teams"],
          badges: raw_info["badges"],
          roles: raw_info["roles"]
        }
      end

      def raw_info
        @raw_info ||= access_token.get("/api/v1/userinfo").parsed
      end

      def callback_url
        options[:redirect_uri] || (full_host + callback_path + query_string)
      end
    end
  end
end
