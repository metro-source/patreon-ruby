module Patreon
  class API
    def initialize(access_token)
      @access_token = access_token
    end

    def fetch_identity(opts = {})
      get_parse_json(Utils::JSONAPI::URLUtil.build_url('identity',  opts[:includes], opts[:fields]))
    end

    def fetch_campaign_members(campaign_id, opts = {})
      params = {}

      if opts[:cursor].present?
        params['page[cursor]'] = opts[:cursor]
      end

      if opts[:count].present?
        params['page[count]'] = opts[:count]
      end

      get_parse_json Utils::JSONAPI::URLUtil.build_url("campaigns/#{campaign_id}/members?#{ Rack::Utils.build_query(params) }",  opts[:includes], opts[:fields])
    end

    def fetch_campaign_member(campaign_id, member_id, opts = {})
      get_parse_json Utils::JSONAPI::URLUtil.build_url("campaigns/#{campaign_id}/members/#{member_id}?#{ Rack::Utils.build_query(params) }", opts[:includes], opts[:fields])
    end

    # def fetch_user(opts = {})
    #   get_parse_json(Utils::JSONAPI::URLUtil.build_url('current_user', opts[:includes], opts[:fields]))
    # end

    # def fetch_campaign(opts = {})
    #   get_parse_json(Utils::JSONAPI::URLUtil.build_url('current_user/campaigns', opts[:includes], opts[:fields]))
    # end

    def access_token= token
      @access_token = token
    end

    private

    def get_parse_json(suffix)
      json = get_json(suffix)
      parse_json(json)
    end

    def get_json(suffix)
      http = Net::HTTP.new("www.patreon.com", 443)
      http.use_ssl = true

      req = Net::HTTP::Get.new("/api/oauth2/v2/#{suffix}")
      req['Authorization'] = "Bearer #{@access_token}"
      req['User-Agent'] = Utils::Client.user_agent_string
      http.request(req).body
    end

    def parse_json(json)
      JSON.parse(json)
    end
  end
end
