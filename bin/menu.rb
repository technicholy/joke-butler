require 'pry'

def jb_text 
  RubyFiglet::Figlet.new("Joke Butler")
end

$user = ""
$joke = ""
$joke_interval = 4.5

def prompt 
    TTY::Prompt.new
end

def new_user
    username = prompt.ask("You're new here, what is your name?")
    return $user if User.find_by(name: username)

    $user = User.create({name: username})
    #new user gets added to db
end

def login
    user = prompt.ask("Please enter your name: ")
    $user = User.find_by(name: user)
    $user.nil? ? new_user : $user
end

def member_access_arr
    ["New Joke", "Old Jokes", "Clear Joke Library", "Delete Account", "Quit"]
end

def member_access 
    prompt.select("Welcome back #{$user.name}, how may I be of service?") do |menu|
        member_access_arr.each_with_index do |choice, index|
            menu.choice choice, index
        end
    end
end

def main_menu_arr
    ["New User", "Login", "Quit"]
end

def main_menu   
    prompt.select("Greetings, I am Joke Butler") do |menu|
        main_menu_arr.each_with_index do |choice, index|
            menu.choice choice, index
        end
    end
end

def main_loop
  print jb_text
  print "\n" * 3
    case main_menu
    when 0 
        system('clear')
        print jb_text
        print "\n" * 3
        new_user
        sleep (1)
        system('clear')
        main_loop
    when 1
        system('clear')
        print jb_text
        print "\n" * 3
        login
        sleep(1)
        system('clear')
        member_loop
    when 2
        system('clear')
        puts "Goodbye"
    end
end

def member_loop
    $user = User.find_by(id: $user.id)
    print jb_text
    print "\n" * 3
    case member_access
    when 0 #new joke
        system('clear')
        print jb_text
        print "\n" * 3
        $joke = Joke.create(random_joke)
        msg = Message.create({user_id: $user.id, joke_id: $joke.id})
        puts msg.joke.joke
        sleep($joke_interval)
        system('clear')
        member_loop
    when 1#old jokes
        begin
        system('clear')
        print jb_text
        print "\n" * 3
        puts $user.jokes.sample.joke
        rescue
        puts "You don't have any old jokes. Reloading menu."
        ensure
        sleep($joke_interval)
        system('clear')
        member_loop
        end
    when 2#clear joke library
        $user.jokes.destroy_all
        system('clear')
        print jb_text
        print "\n" * 3
        puts "Clearing out your jokes..."
        sleep(2)
        system('clear')
        member_loop
    when 3#delete account
        $user.destroy
        system('clear')
        print jb_text
        print "\n" * 3
        puts "Removing your membership..."
        sleep(2)
        system('clear')
        main_loop
    when 4
        system('clear')
        # puts "Goodbye"
    end
end





