class ImageVectorizer
  attr_accessor :path, :model_name, :detector_backend

  def initialize path, model_name='Facenet512', detector_backend='retinaface'
    @path = path
    @model_name = model_name
    @detector_backend = detector_backend
  end

  def perform
    result = `python3 #{Rails.root.join('lib/image_vector.py')} #{path} #{model_name} #{detector_backend}`
    JSON.parse(result.split('result').last.strip)
  rescue
    raise StandardError.new("Error vectorizing #{path}")
  end

  def perform_api
    response = Faraday.post('http://127.0.0.1:2000/represent', body.to_json, { 'Content-Type' => 'application/json' })
    JSON.parse(response.body)['embedding']
  end

  def body
    {
      "model_name": model_name,
      "detector_backend": detector_backend,
      img: image_to_base64
    }
  end

  def image_to_base64
    File.open(path, 'rb') do |img|
      'data:image/png;base64,' + Base64.strict_encode64(img.read)
    end
  end
end