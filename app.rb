require 'bundler'
Bundler.require

class MyApp < Sinatra::Base
  enable :sessions
  set :session_secret, "secret"

  get '/' do
    erb :index    
  end

  post '/results' do
   session[:artist] = params[:artist]

   artist = RSpotify::Artist.search(params[:artist]).first

   if artist == nil
    redirect to('/error')
     
    else 
       related_artist = artist.related_artists.sample
    @song = related_artist.top_tracks(:US).sample.name
    #This is the artist name that will print out on the website
    @related_artist_views = related_artist.name
    @image = related_artist.images.sample["url"]
    @song_play = related_artist.top_tracks(:US).sample.preview_url
      erb :results
    end
  end

  get '/error' do
    erb :error
       # erb :error
  end

  get '/results' do                                               #sessions goes across from the post request to the get request
  
   artist = RSpotify::Artist.search(session[:artist]).first
   related_artist = artist.related_artists.sample
   @song = related_artist.top_tracks(:US).sample.name
   #This is the artist name that will print out on the website
   @related_artist_views = related_artist.name
   @image = related_artist.images.sample["url"]
   @song_play = related_artist.top_tracks(:US).sample.preview_url
    erb :results
  end


end