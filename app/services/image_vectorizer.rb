class ImageVectorizer
  def self.perform path
    result = `python3 #{Rails.root.join('lib/image_vector.py')} #{path}`
    JSON.parse(result.split('result').last.strip)
  rescue
    raise StandardError.new("Error vectorizing #{path}")
  end
end