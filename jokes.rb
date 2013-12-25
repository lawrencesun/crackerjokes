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
	jokes = {#'What school subject are snakes best at?' => 'Hisstory', 
					 #'What do you call a crazy golfer?' => 'A crack put', 
					 #'What lies at the bottom of the sea and shivers?' => 'A nervous wreck',
					 #'What do vampires sing on New Year\'s Eve?' => 'Auld Fang Syne',
					 #'What is black and white and noisy?' => 'A zebra with a drum kit',
					 #'What\'s the fastest thing in water?' => 'A motor pike',
					 #'What lies in a pram and wobbles?' => 'A jelly baby',
					 #'What do you call a blind dinosaur?' => 'A doyouthinkhesawus',
					 #'What do they sing at a snowman\'s birthday party' => 'Freeze a jolly good fellow',
					 #'What kind of sweet goes swinging through the jungle?' => 'Tarzi-pan',
					 #'What\'s the most popular gardening magazine in the world' => 'Weeder\'s digest!',
					 'What do you get if you cross an orange with a comedian?' => 'Peels of laughter',
					 'What would you get if all the cars in Britain were red?' => 'A red carnation',
					 'What is green and stands in the corner?' => 'A naughty frog',
					 'How do monkeys make toast?' => 'Stick some bread under the gorilla',
					 'What do you get if you cross a cowboy with an octopus?' => 'Billy the squid',
					 'What do you get if you cross a hen with a bedside clock?' => 'An alarm cluck',
					 'Where are the Andes?' => 'On the end of the armies',
					 'Who wrote the book, The Awful Comedown' => 'Luck Lastick',
					 'Why can\'t a bike stand up by itself?' => 'Because it\'s two-tired',
					 #'Why did the chicken cross the football pitch?' => 'Because the referee whistled for a fowl',
					 #'Why do you call your dog Metal-worker?' => 'Because every time he hears a knock he makes a bolt for the door',
					 'Why is Europe like a frying pan?' => 'Because it has Greece at the bottom',
					 #'What\'s ET short for?' => 'Because he\'s only got little legs',
					 'Why are chocolate buttons rude?' => 'Because they are Smarties in the nude',
					 'What fur do we get from a tiger?' => 'As fur as possible',
					 'What should a football team do if the pitch is flooded?' => 'Bring on their subs',
					 'What do you get if you cross a chicken with a cement mixer?' => 'A brick-layer',
					 'Who invented fractions?' => 'Henry the 1/8th',
					 'Why do birds fly south in winter?' => 'Because it\'s too far to walk',
					 'How does Jack Frost get to work?' => 'By icicle',
					 'What do you call a penguin in the Sahara desert?' => 'Lost',
					 'Why did the footballer take a piece of rope onto the pitch?' => 'He was the skipper',
					 'What are the small rivers that run into the Nile?' => 'The juve-niles',
					 'How did the Vikings send secret messages?' => 'By Norse code',
					 'What kind of lighting did Noah use for the ark?' => 'Floodlights',
					 'How do you hire a horse' => 'Stand it on four bricks',
					 'What do ghosts eat?' => 'Spookgetti',
					 'What do hedgehogs eat?' => 'Prickled onions',
					 'What cereals do cats like?' => 'Mice Crispies',
					 'What say Oh Oh Oh?' => 'Santa walking backwards',
					 'What do Santa\'s little helpers learn at school?' => 'The elf-abet',
					 'Who is Santa Claus married to?' => 'Mary Christmas',
					 'Why did the turkey cross the road?' => 'Because it was the chicken\'s day off',
					 'Why do ghosts live in fridge?' => 'Because it\'s cool' 
					}
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
	@show_answer = true
	session[:answer_to_show] = session[:answer].pop
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
		halt erb(:joke)
	end

	@show_answer = false
	session[:ask_to_show] = session[:ask].pop
	@reveal = true
	@next = false

	erb :joke
end

get '/joke_over' do
	erb :joke_over
end


