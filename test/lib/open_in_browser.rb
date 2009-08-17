class WWW::Mechanize::Page
  def open_in_browser
    file_name = "blackbook-temporary-#{Time.now.to_i}.html"
    File.open(file_name, 'w') do |f|
      f.write body
    end
    require "launchy"
      Launchy::Browser.run(file_name)
    rescue LoadError
      warn "Sorry, you need to install launchy to open pages: `gem install launchy`"
  end
end