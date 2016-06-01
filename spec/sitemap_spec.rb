require 'spidr/agent'
require 'spidr/page'

require 'spec_helper'

describe Sitemap do
  FIXONE = '
<urlset xmlns="http://www.sitemaps.org/schemas/sitemap/0.9" xmlns:image="http://www.google.com/schemas/sitemap-image/1.1">
<url>
<loc>http://www.coolsite.com.br/item-a</loc>
<lastmod>2015-10-19</lastmod>
<changefreq>daily</changefreq>
<priority>1.0</priority>
</url>
<url>
<loc>http://www.coolsite.com.br/item-b</loc>
<lastmod>2015-10-19</lastmod>
<changefreq>daily</changefreq>
<priority>1.0</priority>
</url>
<url>
<loc>http://www.coolsite.com.br/item-c</loc>
<lastmod>2016-02-29</lastmod>
<changefreq>daily</changefreq>
<priority>1.0</priority>
</url></urlset>'

  let(:sitemap) { Sitemap.new(FIXONE) }
  it 'should parse nicely' do
    expect(sitemap.urls.size).to eq(3)
  end

  it 'should convert to array nicely' do
    expect(sitemap.to_a).to eq(['http://www.coolsite.com.br/item-a',
                                'http://www.coolsite.com.br/item-b',
                                'http://www.coolsite.com.br/item-c'])
  end
end
