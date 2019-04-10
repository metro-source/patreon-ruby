module Patreon
  class API
    def initialize(access_token)
      @access_token = access_token
    end

    def fetch_identity(opts = {})
      get_json(Utils::JSONAPI::URLUtil.build_url('identity',  opts[:includes], opts[:fields]))
    end

    # def fetch_user(opts = {})
    #   get_parse_json(Utils::JSONAPI::URLUtil.build_url('current_user', opts[:includes], opts[:fields]))
    # end

    # def fetch_campaign(opts = {})
    #   get_parse_json(Utils::JSONAPI::URLUtil.build_url('current_user/campaigns', opts[:includes], opts[:fields]))
    # end

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
      JSON.parse(json, object_class: OpenStruct)
    end
  end
end
