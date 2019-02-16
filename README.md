# News
A flutter app that uses hacker news api to fetch and show latest tech news
.
This app is great for learning some of the best features in flutter such as Future builder, Stream Builder and Listview builder...
Hacker News api was designed in such a horrible way that if we use normal api call to fetch data and show them inside our app, it would take huge amount of time. In order to tackle these problems we can cache our data inside our local storage( for example, using sqflite database). Additonally, news will be loaded on demand, that is, initially app will fetch a small portion of data and when a user tries to scroll down, additonal data will be fetched.
