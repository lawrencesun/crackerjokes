require 'rubygems'
require 'sinatra'

set :sessions, true

before do
	@reveal = true
	@next = false
	@show_answer = false
	@another_round = false
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
	@show_answer = true
	@reveal = false
	@next = true

	erb :joke
end

post '/joke/next' do
	if session[:ask].empty?
		@error = "Oops, reached the end."
		@another_round = true
		@show_answer = true
		@reveal = false
		@next = false
		halt erb :joke
	end

	session[:ask_to_show] = session[:ask].pop
	@show_answer = false
	@reveal = true
	@next = false

	erb :joke
end

get '/joke_over' do
	erb :joke_over
end


