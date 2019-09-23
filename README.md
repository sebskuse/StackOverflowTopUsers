## Dependencies
I've included Bond (via Carthage) as a dependency to support the MVVM view binding.

I've also included [Nimble](https://github.com/Quick/Nimble), which is a simple matcher framework for tests.

## Testing
I've included a sample response in the testing bundle so we can validate tests against a known response and not hit the network. Before writing any code, I tend to inspect an API using [Paw](https://paw.cloud). In the past i've set up team instances of this so we can share API structures, add upcoming API requests etc.

## TopUsersRequest
`TopUsersRequest` conforms to the `Request` protocol, which describes a call that can be made to the network.
