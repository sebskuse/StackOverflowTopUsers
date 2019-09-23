A sample project with zero dependencies showing how to retrieve and show the top list of users from the StackOverflow API.


## Testing
I've included a sample response in the testing bundle so we can validate tests against a known response and not hit the network. Before writing any code, I tend to inspect an API using [Paw](https://paw.cloud). In the past i've set up team instances of this so we can share API structures, add upcoming API requests etc.

## Model
Models are decoded off the network using Swift's `Decodable` mechanism.

## Network client

A thin wrapper around `URLSession` for testability. Requests made to the network conform to `Request`, and responses are decoded using `Parsable` - both `Codable` objects and custom responses (such as from an image request).

## TopUsersRequest
`TopUsersRequest` conforms to the `Request` protocol, which describes a call that can be made to the network.

## TopUsersContext
`Context`s wrap data fetching functionality for a View Model, creating a separation between making a network request and receiving data. These can be stubbed out in tests to just return the data.

## Home launch sequence
When launching, the HomeViewModel receives a request from the HomeViewController to fetch users. These are then passed to the `HomeDataSource`, which understands how to enrich them with local state that the `UserCell` can handle (expanded state, blocked, followed, etc). 

I'll often use something like Bond to make this binding easier - negating the need for the datasource.

Profile images are requested as the cells dequeue using a `ProfileImageContext`, which uses `Session` underneath.