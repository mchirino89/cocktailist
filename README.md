# Code Challenge

Simple cocktail catalog app, Swift 4 + cache + minor concurrency

## Features:

**1. Cocktails list:**

Cocktail listing (using a queue for handling all simultaneous image downloads)

Wireframe 1:

![screen shot 2018-02-02 at 12 53 57](https://user-images.githubusercontent.com/263229/35742087-40b1ce26-0818-11e8-91d7-5c2ea0d4a6aa.png)

**2. Cocktail detail:**

Levarage on stored cache to improve performance and save user's bandwidth

![screen shot 2018-02-02 at 12 53 37](https://user-images.githubusercontent.com/263229/35742155-63205b1c-0818-11e8-8b4b-608a46eaa718.png)
	
  
**3. Bonus Points: (Optional)**

Simple cocktail filtering with small toggle animation for search bar

## Questions:

A) Describe the strategy used to consume the API endpoints and the data management.

This is simply Swift 4 vainilla. Why? There's simply no reason for using pods/third party libraries for such small app.

B) Explain which library was used for the routing and why. Would you use the same for a consumer facing app targeting thousands of users? Why?

If I were to deploy this for production then I'd probably use Moya framework since it is very elegant for network management. It includes alamofire so I'd take advantage of it and use cache for images via that way

C) Have you used any strategy to optimize the performance of the list generated for the first feature?

Cache and operation queue

D) Would you like to add any further comments or observations?

There are a ton of validations I'd apply if this was a real app (retry API consumption in case of error, proper testing for internet connection, proper json data handling in case of corrupt data) but this was already consuming me a hugh amount of time for a simple challenge so I left it this size.

Also I left a method unimplemented for downloading the drink image in the detail view in case it wasn't previously downloaded on the previous screen but as mentioned earlier, one of the many validations a production app would have.