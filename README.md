### DinnerHost Bot
This script serves as a pretty basic Twitter bot that periodically goes thru Twitter
looking for tweets with a specific keyword, and replying to them. To run it:

#### Initialize configuration
DinnerHost::Config.initialize!

#### Set up Twitter api client
client = DinnerHost::Config.config your_consumer_key, your_consumer_secret, your_token, your_token_secret

#### Dispatch bot
DinnerHost::Bot.dispatch client, "your_keyword", loop_count, batch_size

loop_count: how many times you want the bot to go 'tweet hunting'
batch_size(optional): how many tweets you want hunted per dispatch (defaults to 1k)