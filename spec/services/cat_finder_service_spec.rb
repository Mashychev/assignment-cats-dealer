# frozen_string_literal: true

require 'rails_helper'

RSpec.describe CatFinderService do
  let(:location) { 'Donezk' }
  let(:cat_name) { 'American Curl' }
  let(:service) { described_class.new(location, cat_name) }

  before { allow(CatFinderAdaptors::CatsUnlimitedAdaptor).to receive(:fetch_data).and_return(cats_data) }

  describe '#call' do
    context 'when there are matching cats' do
      let(:cats_data) do
        [
          { 'name' => 'American Curl', 'price' => 450, 'location' => 'Lviv', 'image' => 'https://olxua-ring07' },
          { 'name' => 'Siberian', 'price' => 300, 'location' => 'Donezk', 'image' => 'https://olxua-ring08' },
          { 'name' => 'American Curl', 'price' => 400, 'location' => 'Donezk', 'image' => 'https://olxua-ring09' },
          { 'name' => 'American Curl', 'price' => 450, 'location' => 'Donezk', 'image' => 'https://olxua-ring10' }
        ]
      end

      it 'returns the cat with the lowest price for the given location and name' do
        result = service.call
        expect(result).to eq({ 'name' => 'American Curl', 'price' => 400, 'location' => 'Donezk', 'image' => 'https://olxua-ring09' })
      end
    end

    context 'when there are no matching cats' do
      let(:cats_data) do
        [
          { 'name' => 'Siberian', 'price' => 300, 'location' => 'Donezk', 'image' => 'https://olxua-ring08' },
          { 'name' => 'British Shorthair', 'price' => 500, 'location' => 'Kyiv', 'image' => 'https://olxua-ring10' }
        ]
      end

      it 'returns nil' do
        result = service.call
        expect(result).to be_nil
      end
    end

    context 'when all adapters return no data' do
      let(:cats_data) { [] }

      it 'raises NoDataAvailableError' do
        expect { service.call }.to raise_error(NoDataAvailableError, 'No data available from any source')
      end
    end

    context 'when adapters return data but no matches for the given location and name' do
      let(:cats_data) do
        [
          { 'name' => 'Siberian', 'price' => 300, 'location' => 'Donezk', 'image' => 'https://olxua-ring08' },
          { 'name' => 'British Shorthair', 'price' => 500, 'location' => 'Kyiv', 'image' => 'https://olxua-ring10' }
        ]
      end

      it 'returns nil because no cats match the given location and name' do
        result = service.call
        expect(result).to be_nil
      end
    end

    context 'when adapters return data but with different locations and names' do
      let(:cats_data) do
        [
          { 'name' => 'Persian', 'price' => 300, 'location' => 'Lviv', 'image' => 'https://olxua-ring08' },
          { 'name' => 'Bengal', 'price' => 600, 'location' => 'Odesa', 'image' => 'https://olxua-ring10' }
        ]
      end

      it 'returns nil because no cats match the given location and name' do
        result = service.call
        expect(result).to be_nil
      end
    end
  end
end
