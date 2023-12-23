xml.instruct! :xml, version: "1.0"
xml.rss version: "2.0" do
  xml.channel do
    xml.title ENV['APP_NAME']
    xml.description ENV['MOTTO']
    xml.link blogs_url

    @blogs.each do | blog|
      xml.item do
        xml.title blog.title
        xml.description blog.teaser
        xml.pubDate blog.created_at.rfc822()
        xml.link blog_url(blog)
        xml.guid blog_url(blog)
      end
    end
  end
end