require 'rubygems'
require 'sinatra'

set :sessions, true

before do
	@reveal_or_next = true

end


get '/' do 
	if session[:speaker_name]
		redirect '/joke'
	else
		redirect '/new_speaker'
	end

end

get '/new_speaker' do
	erb :new_speaker
end

post '/new_speaker' do
	if params[:speaker_name].empty?
		@error = 'Name is required.'
		halt erb(:new_speaker)
	end

	session[:speaker_name] = params[:speaker_name].capitalize

	redirect '/joke'

end

get '/joke' do
	jokes = Hash.new
	jokes = {'a1' => 'b1', 
					 'a2' => 'b2', 
					 'a3' => 'b3'}
	session[:ask] = []
	session[:answer] = []
	session[:ask] = jokes.keys.to_a.shuffle!
	
	session[:ask].each do |x|
		session[:answer] << jokes[x]
	end

	session[:ask_to_show] = session[:ask].pop
	
	erb :joke

end

post '/joke/reveal' do
	session[:answer_to_show] = session[:answer].pop

	erb :joke

end

post '/joke/next' do
	session[:ask_to_show] = session[:ask].pop

	erb :joke

end



