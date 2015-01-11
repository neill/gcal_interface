Mobiquity Coding Challenge
====

Using Devise for authentication and Google's Calendar API.

Steps for setting up:
1. Run bundle install.

2. Run rake db:migrate.

3. Set up Google API.
   A. Go to 'https://console.developers.google.com'
   B. Set up API profile
   C. Enable Contacts API and Google+ API.
   D. Allow "http://127.0.0.1:3000/users/auth/google_oauth2/callback" as a path in your redirect.

4. Set environment variables (for config/intializers/omniauth.rb),
ENV["CONSUMER_KEY"] = Google OAuth client ID
ENV["CONSUMER_SECRET"] = Google OAuth client secret.

4.5 Run "source ~/.bashrc" in the terminal to load the environment variables.


