require File.join( File.dirname(__FILE__), '..', 'lib', 'blackbook.rb' )
require File.join( File.dirname(__FILE__), 'test_helper.rb' )
require 'test/unit'
require 'mocha'
require 'logger'

class TestLogging < Test::Unit::TestCase

  include TestHelper
  
  def setup
    super
    Blackbook.logger = Logger.new(STDERR)
    @importer = Blackbook::Importer::Yahoo.new
    @importer.options = {:username => 'user@yahoo.com', :password => 'password'}
    @importer.create_agent
  end
  
  def teardown
    Blackbook.logger = nil
    super
  end
  
  def test_logs_error
    response = {'content-type' => 'text/html'}
    stage1_contacts = load_fixture('yahoo_contacts_stage_1.html').join
    page = WWW::Mechanize::Page.new(uri=nil, response, stage1_contacts, code=nil, mech=nil)
    @importer.agent.stubs(:get).returns(page)

    response = {'content-type' => 'text/csv; charset=UTF-8'}
    body = load_fixture('yahoo_contacts.csv').join
    page = WWW::Mechanize::File.new(uri=nil, response, body, code=nil)
    @importer.agent.stubs(:submit).returns(page)
    FasterCSV.stubs(:parse).raises(Blackbook::BlackbookError.new)
    
    Blackbook.logger.expects(:error).with { |arg| arg.include?(stage1_contacts) }
    
    begin
      @importer.scrape_contacts
    rescue Blackbook::BlackbookError
    end
  end

  def test_nil_logger_ok
    Blackbook.logger = nil
    
    response = {'content-type' => 'text/html'}
    body = load_fixture('yahoo_contacts_stage_1.html').join
    page = WWW::Mechanize::Page.new(uri=nil, response, body, code=nil, mech=nil)
    @importer.agent.stubs(:get).returns(page)

    response = {'content-type' => 'text/csv; charset=UTF-8'}
    body = load_fixture('yahoo_contacts.csv').join
    page = WWW::Mechanize::File.new(uri=nil, response, body, code=nil)
    @importer.agent.stubs(:submit).returns(page)
    FasterCSV.stubs(:parse).raises(Blackbook::BlackbookError.new)
    
    Blackbook.logger.expects(:error).never
    
    assert_raises(Blackbook::BlackbookError) do
      @importer.scrape_contacts
    end    
  end

end
