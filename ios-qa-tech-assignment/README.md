# iOS QA Technical Challenge

We have provided some tasks for you to complete to show us your approach to UI testing.

We are looking for:

- How you present, organise and layout your tests
- How you test different scenarios
- How complete your tests are
- Your approach to testing

We understand that your time is valuable. So if you are unable to provide us with a complete solution, note down any next steps that you would take given more time in your README.

## The Test Project

The contained Xcode project creates a mini news app, consisting of a list of headlines and an article detail view.

When the user selects one of the headlines from the list view, then the article detail view is presented.

The user can sort the articles in the list view in four different ways, and can bookmark an article by:

- Tapping on the bookmark icon in the list view, which will change the icon to a filled state when bookmarked
- Tapping on the "Add To Bookmarks" button in the article view, which will change the button text to "Remove From Bookmarks"

The article detail view consists of a scrollable view with:

- An image
- An image credit label underneath the image
- A headline
- A bookmark button underneath the headline
- The article body text

## Tasks

Create two test plans that test the functionality for the list view and article detail view respectively.

We have already created the list view test plan for you. If you are unable to create the second test plan, you can add all of the tests to the list view test plan.

### List View Tests
1. Test that the app correctly displays a list of 20 articles
2. Test that bookmarking an article behaves as expected
3. Test that sorting alphabetically by headline works as expected
4. Test that sorting alphabetically by bookmarked state works as expected
5. Test that all types are correctly displayed in the list e.g. news, opinion, live


### Article Detail Tests
1. Test that bookmarking an article behaves as expected
2. Test that a user can scroll through the article, and all elements are present
3. Test that all articles display an image credit
4. Test that all types are correctly displayed in the

If you need to mock any data, you may do so by replacing the injected property with InjectedValues[\.imageAPIService] = ...

The goal here is not to look at the tests you implemented but rather how you've structured the framework and how did you leveraged swift features to improve re-usability.

We also expect your code to be a reflection of yourself at work, so we will be attentive to the choices you'll make regarding code readability and organisation.

## Submission

The quickest way to submit your work is by creating a repo on Github, Gitlab, Bitbucket copy this repository to your personal space, and send us a link to your branch (if you make your repo private, you'll need to [invite us as collaborators](https://help.github.com/en/articles/inviting-collaborators-to-a-personal-repository)).
