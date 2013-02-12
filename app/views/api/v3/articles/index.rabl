collection ArticleDecorator.decorate(@articles)
key = ["v1", ArticleDecorator.decorate(@articles)]
Rails.cache.read(ActiveSupport::Cache.expand_cache_key(key, :rabl))
  
attributes :doi, :title, :url, :mendeley, :pmid, :pmcid, :publication_date

unless params[:info] == "summary"
  child :retrieval_statuses => :sources do
    attributes :name, :events_url, :metrics, :update_date
    
    attributes :events if ["detail","event"].include?(params[:info])
    attributes :histories if ["detail","history"].include?(params[:info])
  end
end