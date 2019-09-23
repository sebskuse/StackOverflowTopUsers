## Testing
I've included a sample response in the testing bundle so we can validate tests against a known response and not hit the network. Before writing any code, I tend to inspect an API using [Paw](https://paw.cloud). In the past i've set up team instances of this so we can share API structures, add upcoming API requests etc.

## TopUsersRequest
`TopUsersRequest` conforms to the `Request` protocol, which describes a call that can be made to the network.

## TopUsersContext
`Context`s wrap data fetching functionality for a View Model, creating a separation between making a network request and receiving data. These can be stubbed out in tests to just return the data.
