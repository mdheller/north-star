# frozen_string_literal: true

class Server < Sinatra::Base
  helpers Sinatra::Cookies
  helpers Sinatra::MderbRenderer
  register Sinatra::Configs::Assets
  register Sinatra::Configs::I18n
  register Sinatra::Configs::Storage
  register Sinatra::SiteModules::LocaleSelect
  use Rack::Protection::PathTraversal

  configure do
    set :markdown_renderer, ::MarkdownRenderer.new
  end

  not_found do
    document = settings.storage.load_document("meta", "404")
    mderb(document)
  end

  before do
    @config = settings.storage.load_data("config")
  end

  get "/*/*" do |section, document_path|
    document = settings.storage.load_document(section, document_path)
    halt 404 unless document
    mderb(document)
  end

  get "/" do
    document = settings.storage.load_document("meta", "dev_index")
    mderb(document)
  end
end
