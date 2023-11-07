require File.join(__dir__, "./ISBaseWatir.rb")

class ISBlog < ISBaseWatir
  
  def initialize 
    super
    
    remove_test_data!
    create_and_confirm_admin_user!
    
    sign_in_admin
    
    create_blog 
    
    update_blog 
    search_blogs
    
    publish_blog 

    browse_blogs

    delete_blog
    
  end

  def test_blog 
    {
      title: "Test blog",
      teaser: "Teaser",
      content: "Content"
    }
  end
  
  def test_blog_record 
    blog = Blog.find_by(title: test_blog[:title])
    blog = Blog.find_by(title: "Changed") if blog.nil?
    blog
  end

  def remove_test_data!
    # Blog.where(title: test_blog[:title]).destroy_all
    Blog.destroy_all
  end

  def create_blog 
    header("Create Blog")

    link = @browser.link(href: '/admin/blogs')
    link.click
    
    @browser.scroll.to :bottom
    sleep 1
    
    @browser.wait_until { @browser.text.include? 'Blogs' }
    good("browsed to admin/blogs")


    link = @browser.link(href: '/admin/blogs/new')
    link.click
    @browser.wait_until { @browser.text.include? 'New Blog' }
    good("browsed to admin/blogs/new")
    
    sleep 2 # Give javascript time to set the page up..

    text_field = @browser.text_field(id: 'blog_title')
    text_field.value = test_blog[:title]

    string = File.join(__dir__,'./images/')
    string += "Test_pattern.png"

    @browser.file_field.set(string)

    javascript_script = "document.getElementById('blog_teaser_trix_input_blog').value = '<div>#{test_blog[:teaser]}</div>'"
    @browser.execute_script(javascript_script)
     
    javascript_script = "document.getElementById('blog_content_trix_input_blog').value = '<div>#{test_blog[:content]}</div>'"
    @browser.execute_script(javascript_script)

    @browser.scroll.to :bottom
    sleep 2

    @browser.button(:id => "blog_save_button").click
    @browser.wait_until { @browser.text.include? 'Blog was successfully created' }
    good("blog created")
  end
  
  def update_blog 
    header("Update Blog")

    blog = test_blog_record
    
    link = @browser.link(href: "/admin/blogs/#{blog.id}/edit")
    link.click
    @browser.wait_until { @browser.text.include? 'Edit Blog' }
    good("browsed to admin/blogs")
    
    text_field = @browser.text_field(id: 'blog_title')
    text_field.value = test_blog[:title]

    @browser.scroll.to :bottom
    sleep 1
    
    @browser.button(:id => "blog_save_button").click
    @browser.wait_until { @browser.text.include? 'Blog was successfully updated.' }
    good("updated blog")
  end
  
  def publish_blog 
    header("Publish Blogs")
  end

  def search_blogs
    header("Search Blogs")
    
    link = @browser.link(href: "/admin/blogs")
    link.click
    @browser.wait_until { @browser.text.include? 'Blogs' }
    good("browsed to admin/blogs")
    
    text_field = @browser.text_field(id: 'filter_title')
    text_field.value = "zz"
    @browser.button(:id => "blogs_filter_button").click
    @browser.wait_until { @browser.text.include? 'There are no Blogs' }
    good("blog search successfull")

    text_field = @browser.text_field(id: 'filter_title')
    text_field.value = ""
    @browser.button(:id => "blogs_filter_button").click
  end
  
  def delete_blog
    header("Delete Blog")

    @browser.goto "#{@base_url}/admin/blogs"
    
    blog = test_blog_record
    @browser.button(:id => "admin_blog_delete_blog_#{blog.id}").click

    case @browser.alert.exists?
    when true  then good("delete prompt")
    when false then bad("no delete prompt")
    end

    @browser.alert.ok
    
    @browser.wait_until { @browser.text.include? 'Blog was successfully destroyed' }
    good("blog delete successfull")
  end
  
  def browse_blogs 
    header("Browse Blog")
    go_home 
    
    link = @browser.link(href: "/blogs")
    link.click
    @browser.wait_until { @browser.text.include? 'Sidebar' }
    good("browsed to /blogs")
  end
  
  
end

ISBlog.new
