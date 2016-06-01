module Spidr
  #
  # The Sitemap Parser
  #
  # Currently parsed data:
  #
  # <urlset xmlns="http://www.sitemaps.org/schemas/sitemap/0.9"...
  #   <url>
  #     <loc>
  #       http://www.coolsite.com.br/cool-page
  #     </loc>
  #   </url>
  #   ....
  #
  # Optional data on <url>:
  #
  #   <lastmod>2015-09-05</lastmod>
  #   <changefreq>daily</changefreq>
  #   <priority>0.7</priority>
  #   <image:image>
  #     <image:loc>
  #       http://www.coolsite/media/cool-pic.jpg
  #     </image:loc>
  #   </image:image>
  #
  # Thanks to benbalter/sitemap-parser
  class Sitemap
    # Sitemap data
    attr_reader :path

    # Sitemap data
    attr_reader :body

    def initialize(raw, opts = {})
      # raw = Agent.new.get_page(url)
      @body = Nokogiri::XML(raw)
      @opts = opts
      @opts[:recurse] = true if opts[:recurse].nil?
    end

    # Recurse sitemaps
    def recursive_urls
      return unless @opts[:recurse]
      body.at('sitemapindex').search('sitemap').map do |s|
        sitemap_location = s.at('loc').content
        self.class.new(sitemap_location, recurse: false).urls
      end.flatten
    end

    # Gets all urls, at urlset rootpath or recursive sitemaps
    def urls
      return body.at('urlset').search('url') if body.at('urlset')
      return recursive_urls if body.at('sitemapindex')
      raise 'Malformed sitemap, no urlset'
    end

    # Maps all XML <loc> nodes to text
    def to_a
      urls.map { |url| url.at('loc').content }
    end
  end
end
