#!/bin/bash

# Ubuntu
	# Run the following commands for the 1st time on the terminal
		# 1 sudo apt-get install dos2unix
		# 2 dos2unix db_setup.sh
		# 3 chmod +x db_setup.sh
		# 4 ./db_setup.sh

# Drop the existing database
rails db:drop

# Create a new database
rails db:create

# Run any pending migrations
rails db:migrate

# Reindex Searchkick for the Profile model
rake searchkick:reindex CLASS=Profile

# Reindex Searchkick for the BenchChannel model
rake searchkick:reindex CLASS=BenchChannel

# Reindex Searchkick for the ConversationMessage model
rake searchkick:reindex CLASS=ConversationMessage

# Clear the Redis database
redis-cli flushdb

# Seed the database with initial data
rails db:seed
