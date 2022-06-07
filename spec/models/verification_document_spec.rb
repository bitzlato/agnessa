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
        vector: vectors[img.to_s].presence
      }
      doc = create(:verification_document, :image, common_image_attributes.merge(image_attributes))
      unless doc.vector.present?
        doc.update_vector
        vectors[img.to_s] = doc.vector
        File.open(json_path, 'w') { |file| file.write(vectors.to_json) }
      end
    end

    image = VerificationDocument.last
    expect(image.similar_vector.map{|x| [x.read_attribute(:file), x.similarity]}.first).to eq(["img1.jpg", 0.8570948859369171])
  end
end
