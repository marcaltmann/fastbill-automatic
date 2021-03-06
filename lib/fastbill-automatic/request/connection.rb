module Fastbill
  module Automatic
    module Request
      class Connection
        attr_reader :https

        def initialize(request_info)
          @info = request_info
        end

        def setup_https
          @https             = Net::HTTP.new(API_BASE, Net::HTTP.https_default_port)
          @https.use_ssl     = true
        end

        def request
          https.start do |connection|
            https.request(https_request)
          end
        end

        protected

        def https_request
          https_request = Net::HTTP::Post.new(@info.url)
          https_request.basic_auth(Fastbill::Automatic.email, Fastbill::Automatic.api_key)
          body = {service: @info.service}
          body[(@info.service.include?('.get') ? :filter : :data)] = @info.data
          https_request['Content-Type'] = 'application/json'
          https_request.body = body.to_json
          https_request
        end
      end
    end
  end
end
