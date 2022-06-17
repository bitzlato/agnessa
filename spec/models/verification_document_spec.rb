require 'rails_helper'

RSpec.describe VerificationDocument, type: :model do
  let(:verification) { create(:verification)}
  let(:common_image_attributes) { {verification: verification, document_type: verification.account.document_types.image.first} }
  let(:image_document) { create(:verification_document, :image, common_image_attributes) }
  let(:json_path) { Rails.root.join("spec/fixtures/similarity/vectors.json") }

  it 'finds correct similarities' do
    vectors = JSON.parse(File.read(json_path))
    ((1..40).to_a + ['clooney']).each do |img|
      image_attributes = {
        file: File.open(Rails.root.join("spec/fixtures/similarity/img#{img}.jpg")),
        neighbor_vector: vectors[img.to_s].presence
      }
      doc = create(:verification_document, :image, common_image_attributes.merge(image_attributes))
      unless doc.neighbor_vector.present?
        doc.update_vector
        vectors[img.to_s] = doc.neighbor_vector
        File.open(json_path, 'w') { |file| file.write(vectors.to_json) }
      end
    end

    image = VerificationDocument.last
    result = image.nearest_neighbors(distance: "cosine").map{|x| x.neighbor_distance}.first
    expect(result).to eq(0.14290511179819076)
  end
end
