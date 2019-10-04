---
title: Introduction
description: Standalone pub/sub API
layout: gem-single
type: gem
name: dry-events
---

dry-events is a library providing pub/sub API allowing you to create event publishers and a convenient way of subscribing to the events. This library is used as the pub/sub backend in dry-monitor, which also powers monitoring plugin in dry-system.


### Quick start

Publishers are created using `Dry::Events::Publisher` extension, which is created by providing a unique identifier. An extended class can be used to define the type of events it can publish:

``` ruby
require 'dry/events/publisher'

class Application
  include Dry::Events::Publisher[:my_publisher]

  register_event('users.created')
end
```

You can publish events via `Publisher#publish` method:

``` ruby
app = Application.new

app.publish('users.created', user: 'Jane')
```

### Subscribing to events

There are two ways that you can use to subscribe to events:

- Block-based subscription
- Event listener objects, where a naming convention is used in order to determine which methods should respond to events


### Block-based subscribers

To subscribe to an event using a block, simply pass it to `Publisher#subscribe` method:


``` ruby
app.subscribe('users.created') do |event|
  puts "EVENT #{event.id}"
  puts "USER #{event[:user]}"
end

app.publish('users.created', user: 'Jane')

# output:
# EVENT users.created
# USER Jane
```

### Event listeners

An event listener object must implement methods that correspond to the following naming convention:

- `"users.created"` event is handled by `#on_users_created` method

Here's a simple example:

``` ruby
class EventListener
  def on_users_created(event)
    puts "EVENT #{event.id}"
    puts "USER #{event[:user]}"
  end
end

event_listener = EventListener.new

app.subscribe(event_listener)

app.publish('users.created', user: 'Jane')

# output:
# EVENT users.created
# USER Jane
```

You can also **unsubscribe** an event listener via `Publisher#unsubscribe` method:

``` ruby
app.unsubscribe(event_listener)

# this will no longer invoke event_listener
app.publish('users.created', user: 'Jane')
```
