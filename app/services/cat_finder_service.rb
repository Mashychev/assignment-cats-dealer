class CatFinderService
  ADAPTORS = [CatFinderAdaptors::CatsUnlimitedAdaptor]

  def initialize(location, cat_name)
    @location = location
    @cat_name = cat_name
  end

  def call
    cats_data = fetch_all_cats_data
    raise NoDataAvailableError, 'No data available from any source' if cats_data.empty?
    
    filtered_cats = filter_cats(cats_data, @location, @cat_name)
    find_best_match(filtered_cats)
  end

  private

  def fetch_all_cats_data
    ADAPTORS.flat_map do |adapter|
      adapter.fetch_data
    end
  end

  def filter_cats(cats_data, location, cat_name)
    cats_data.select do |cat|
      cat['location'] == location && cat['name'] == cat_name
    end
  end

  def find_best_match(cats)
    cats.min_by { |cat| cat['price'].to_f }
  end
end