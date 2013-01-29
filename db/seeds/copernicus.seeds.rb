# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).

# Load default groups
usage = Group.find_or_create_by_name(:name => "Article Usage")
citations = Group.find_or_create_by_name(:name => "Citations")
social_networks = Group.find_or_create_by_name(:name => "Social Networks")
blogs_media = Group.find_or_create_by_name(:name => "Blogs and Media Coverage")

# Load default sources
citeulike = Citeulike.find_or_create_by_name(  
	:name => "citeulike", 
	:display_name => "CiteULike", 
  :description => "CiteULike is a free social bookmarking service for scholarly content.",
	:active => true, 
	:workers => 1,
	:group_id => social_networks.id,
	:url => "http://www.citeulike.org/api/posts/for/doi/%{doi}" )
  
scienceseeker = ScienceSeeker.find_or_create_by_name(  
	:name => "scienceseeker", 
	:display_name => "ScienceSeeker", 
  :description => "Research Blogging is a science blog aggregator.",
	:active => true, 
	:workers => 1,
	:group_id => blogs_media.id,
	:url => "http://scienceseeker.org/search/default/?type=post&filter0=citation&modifier0=doi&value0=%{doi}" )
  
wikipedia = Wikipedia.find_or_create_by_name(  
  :name => "wikipedia", 
  :display_name => "Wikipedia", 
  :description => "Wikipedia is a free encyclopedia that everyone can edit.",
  :active => true, 
  :workers => 1,
  :group_id => citations.id,
  :url => "http://%{host}/w/api.php?action=query&list=search&format=json&srsearch=%{doi}&srnamespace=0&srwhat=text&srinfo=totalhits&srprop=timestamp&srlimit=1")

# The following sources require passwords/API keys
copernicus = Copernicus.find_or_create_by_name(  
  :name => "copernicus", 
  :display_name => "Copernicus", 
  :description => "Usage stats for Copernicus articles.",
  :active => false, 
  :workers => 1,
  :group_id => usage.id,
  :url => "http://harvester.copernicus.org/api/v1/articleStatisticsDoi/doi:%{doi}.json",
  :username => "EXAMPLE",
  :password => "EXAMPLE")
  
mendeley = Mendeley.find_or_create_by_name(  
  :name => "mendeley", 
  :display_name => "Mendeley", 
  :description => "Mendeley is a reference manager and social bookmarking tool.",
  :active => false, 
  :workers => 1,
  :group_id => social_networks.id,
  :url => "http://api.mendeley.com/oapi/documents/details/%{id}/?consumer_key=%{api_key}",
  :url_with_type => "http://api.mendeley.com/oapi/documents/details/%{id}/?type=%{doc_type}&consumer_key=%{api_key}",
  :url_with_title => "http://api.mendeley.com/oapi/documents/search/title:%{title}/?items=10&consumer_key=%{api_key}",
  :related_articles_url => "http://api.mendeley.com/oapi/documents/related/%{id}?consumer_key=%{api_key}",
  :api_key => "EXAMPLE")
  
crossref = CrossRef.find_or_create_by_name(  
  :name => "crossref", 
  :display_name => "CrossRef", 
  :description => "CrossRef is a non-profit organization that enables cross-publisher citation linking.",
  :active => false, 
  :workers => 1,
  :group_id => citations.id,
  :default_url => "http://www.crossref.org/openurl/?pid=%{pid}&id=doi:%{doi}&noredirect=true",
  :url => "http://doi.crossref.org/servlet/getForwardLinks?usr=%{username}&pwd=%{password}&doi=%{doi}",
  :username => "EXAMPLE",
  :password => "EXAMPLE")
  
facebook = Facebook.find_or_create_by_name(  
  :name => "facebook", 
  :display_name => "Facebook", 
  :description => "Facebook is the largest social network.",
  :active => false, 
  :workers => 1,
  :group_id => social_networks.id,
  :url => "https://graph.facebook.com/fql?access_token=%{access_token}&q=select url, normalized_url, share_count, like_count, comment_count, total_count, click_count, comments_fbid, commentsbox_count from link_stat where url = '%{query_url}'",
  :access_token => "EXAMPLE")
  
nature = Nature.find_or_create_by_name(  
  :name => "nature", 
  :display_name => "Nature Blogs", 
  :description => "Nature Blogs is a science blog aggregator.",
  :active => false, 
  :workers => 1,
  :group_id => blogs_media.id,
  :url => "http://api.nature.com/service/blogs/posts.json?api_key=%{api_key}&doi=%{doi}",
  :api_key => "EXAMPLE")
    
researchblogging = Researchblogging.find_or_create_by_name(  
  :name => "researchblogging", 
  :display_name => "Research Blogging", 
  :description => "Research Blogging is a science blog aggregator.",
  :active => false, 
  :workers => 1,
  :group_id => blogs_media.id,
  :url => "http://researchbloggingconnect.com/blogposts?count=100&article=doi:%{doi}",
  :username => "EXAMPLE",
  :password => "EXAMPLE")