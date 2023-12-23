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
    
    tests_complete
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
    blog = Blog.find_by(title: changed) if blog.nil?
    blog
  end

  def remove_test_data!
    # Blog.where(title: test_blog[:title]).destroy_all
    Blog.destroy_all
  end

  def create_blog 
    header("Create Blog")

    click '/admin/blogs'
    
    scroll_to_bottom
    
    wait_for_text 'Blogs'

    click '/admin/blogs/new'

    wait_for_text 'New Blog'
    
    sleep 2 # Give javascript time to set the page up..

    set_text_field('blog_title', test_blog[:title])

    string = File.join(__dir__,'./images/')
    string += "Test_pattern.png"

    @browser.file_field.set(string)

    execute_javascript("document.getElementById('blog_teaser_trix_input_blog').value = '<div>#{test_blog[:teaser]}</div>'")

    execute_javascript("document.getElementById('blog_content_trix_input_blog').value = '<div>#{test_blog[:content]}</div>'")    
     
    scroll_to_bottom(2)

    click_button "blog_save_button"

    wait_for_text 'Blog was successfully created'
  end
  
  def update_blog 
    header("Update Blog")

    blog = test_blog_record
    
    click "/admin/blogs/#{blog.id}/edit"

    wait_for_text 'Edit Blog'
    
    set_text_field('blog_title', test_blog[:title])

    scroll_to_bottom
    
    click_button "blog_save_button"
    
    wait_for_text 'Blog was successfully updated'
  end
  
  def publish_blog 
    header("Publish Blogs")
  end

  def search_blogs
    header("Search Blogs")
    
    click "/admin/blogs"

    wait_for_text 'Blogs'
    
    set_text_field('filter_title', "zz")
    
    click_button "blogs_filter_button"

    wait_for_text 'There are no Blogs'

    set_text_field('filter_title', "")
    
    click_button "blogs_filter_button"
  end
  
  def delete_blog
    header("Delete Blog")

    @browser.goto "#{@base_url}/admin/blogs"
    
    blog = test_blog_record

    click_button "admin_blog_delete_blog_#{blog.id}"

    case @browser.alert.exists?
    when true  then good("delete prompt")
    when false then bad("no delete prompt")
    end

    alert_ok
    
    wait_for_text 'Blog was successfully destroyed'
  end
  
  def browse_blogs 
    header("Browse Blog")
    go_home 
    
    click "/blogs"

    wait_for_text 'Sidebar'

    routes = Rails.application.routes.url_helpers
    goto routes.blogs_url(format: :xml)
    
    wait_for_text ENV['APP_NAME']
  end
  
end

ISBlog.new
