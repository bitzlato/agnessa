require 'rails_helper'

RSpec.describe VerificationDocument, type: :model do
  let(:verification) { create(:verification)}
  let(:common_image_attributes) { {verification: verification, document_type: verification.account.document_types.image.first} }
  let(:image_document) { create(:verification_document, :image, common_image_attributes) }

  it 'finds correct similarities' do
    vectors = JSON.parse(File.read(Rails.root.join("spec/fixtures/similarity/vectors.json")))
    %w(1 2 3 4 5 clooney).each do |img|
      image_attributes = {
        file: File.open(Rails.root.join("spec/fixtures/similarity/#{img}.jpg")),
        vector: vectors[img]
      }
      create(:verification_document, :image, common_image_attributes.merge(image_attributes))
    end
    image = VerificationDocument.last
    expect(image.similar_vector.map{|x| [x.read_attribute(:file), x.similarity]}.first).to eq(["2.jpg", 0.8046402577185594])
  end
end
