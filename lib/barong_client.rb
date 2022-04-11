class BarongClient
  OPEN_TIMEOUT = 10 # opening connection timeout in seconds
  TIMEOUT = 300 # waiting for response timeout in seconds

  def get_uid_from_changebot_id id
    response = client.get("/api/v2/barong/public/user_uid_by_changebot_id/#{id}")
    response.assert_success!
    response.body['uid']
  end

  def client
    Faraday.new(ENV.fetch('AGNESSA_BARONG_API_ROOT_URL')) do |conn|
      conn.response :json
      conn.adapter Faraday.default_adapter
      conn.options.open_timeout = OPEN_TIMEOUT
      conn.options.timeout = TIMEOUT
    end
  end
end