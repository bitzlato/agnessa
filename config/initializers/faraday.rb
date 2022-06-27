class Faraday::Response
  def assert_success!
    raise "Response is not succcess #{status} with body #{body.to_s.truncate(100)}" unless success?
  end
end
