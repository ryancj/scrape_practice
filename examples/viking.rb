#Viking Blog Tutorial
require 'mechanize'
require 'pry-byebug'

scraper = Mechanize.new #Initialize Scraper
scraper.history_added = Proc.new { sleep 0.5 } #Rate limiting, call back when it visits a site

ADDRESS = 'http://sfbay.craigslist.org/search/sfc/apa' #Scraping address Constant

results = [] #Store what we found

scraper.get(ADDRESS) do |search_page| #Go to address, search page is what we see

  search_form = search_page.form_with(id: 'searchform') do |search| #Find the search form with id
    search['query'] = 'Garden'
    search['min_price'] = 250
    search['min_price'] = 1500
  end

  results_page = search_form.submit #Results page

  raw_results = results_page.search('li.result-row') #Find for each listed result

  raw_results.each do |result| #For each listed result
    link = result.css('a')[1]
    name = link.text.strip
    url = "http://sfbay.craigslist.org" + link.attributes["href"].value
    price = result.search('span.price').text
    location = result.search('span.pnr').text[3..-13]

    # Save results
    results << [name, url, price, location]

    binding.pry
  end
end

puts results
