# README

Clone/download then run bundle install, rails db:create.
Run rails server and simply select a valid CSV file to import. The app will then automatcially display the summarised information for the file.

NB: it is assumed in this implementation that all employees are paid at same rate and that pay periods for a given from / to timeframe will always be in the month where the timeframe went to (i.e. from 31 Jan 23:00 to 1 Feb 02:00 would result in a pay period of Feb.)

It is also assumed that the format of the CSV files will always be the same (i.e. the headings and columns will not change).

Can be tested with rspec (bundle exec rspec from console)