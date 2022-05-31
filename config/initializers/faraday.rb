class Faraday::Response
  def assert_success!
    raise "Response is not succcess #{status}" unless success?
  end
end
