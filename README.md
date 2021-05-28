# lita-mattermost

Lita adapter to connect to Mattermost

## Installation

Add lita-mattermost to your Lita instance's Gemfile:

``` ruby
gem "lita-mattermost"
```

## Configuration

```
config.robot.adapter = :mattermost
config.adapters.mattermost.server = <mattermost server url>
config.adapters.mattermost.token = <bot token>
```
