class BarongClient
  include Singleton

  OPEN_TIMEOUT = 10 # opening connection timeout in seconds
  TIMEOUT = 300 # waiting for response timeout in seconds

  def initialize(api_root_url: ENV.fetch('AGNESSA_BARONG_API_ROOT_URL'))
    @uri = URI api_root_url
  end

  def get_barong_uid_from_changebot_id id
    response = client.get(uri.path + "/public/user_uid_by_changebot_id/#{id}")
    response.assert_success!
    response.body['uid']
  rescue URI::InvalidURIError
    nil
  end

  def get_p2pid_from_barong_uid id
    response = client.get(uri.path + "/public/user_uid_by_changebot_id/#{id}")
    response.assert_success!
    response.body['p2p_user_id']
  rescue URI::InvalidURIError
    nil
  end

  private

  attr_reader :uri

  def client
    Faraday.new uri do |conn|
      conn.response :json
      conn.adapter Faraday.default_adapter
      conn.options.open_timeout = OPEN_TIMEOUT
      conn.options.timeout = TIMEOUT
    end
  end
end
