**JournalBits** 

[ ![Codeship Status for journalbits/journalbits](https://www.codeship.io/projects/e0b43c80-db92-0131-5e33-32348e3cf281/status)](https://www.codeship.io/projects/24458)

**Dependencies**

Rails: 4.1
Ruby: 2.1.2
Database: Postgres

*Configuration:*

* You need to setup your own Twitter Application on the Twitter Dev portal and save its key and secret in environment variables
* Currently that is all the setup required other than running rake db:create and then rake db:migrate


This is a work in progress. I am working towards implementing a digital journal that collets all of your data each day from the following services, using their APIs:

   * GitHub
   * Twitter
   * Facebook
   * Wunderlist
   * Pocket
   * Fitbit
   * WhatPulse
   * RescueTime
   * Evernote
   * Instapaper
   * Instagram
   * Last.fm
   * Moves
   * Health Graph

Potentially others will be added but those are the inital services I'm aiming for.

Currently the data model I have in mind is that a User has many "days", and a day has many "$service$_entries". Each of the entires for each service will contain data from the relevant API, for example a username, date and text for a tweet from Twitter's API. This will be available to be viewed in the app and/or via a daily/weekly email.