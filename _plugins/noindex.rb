# Keeps the whole site out of search engines while `noindex: true` is set in _config.yml.
# al-folio has no setting for this, so the tag is added to the <head> of every HTML page at build time.
# Robots are still allowed to fetch the pages (robots.txt), because a page they cannot fetch
# cannot tell them not to index it. Set `noindex: false` to let search engines list the site.
module SiteNoindex
  TAG = %(<meta name="robots" content="noindex, nofollow">).freeze

  def self.apply(doc)
    return unless doc.site.config["noindex"]
    return unless doc.respond_to?(:output_ext) && doc.output_ext == ".html"
    return if doc.output.nil? || doc.output.include?(TAG)

    doc.output = doc.output.sub(/<head(\s[^>]*)?>/i) { |head| "#{head}\n#{TAG}" }
  end
end

Jekyll::Hooks.register [:pages, :documents], :post_render do |doc|
  SiteNoindex.apply(doc)
end
