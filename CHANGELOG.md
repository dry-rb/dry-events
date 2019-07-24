# v0.2.0 2019-07-24

## Fixed

* Trying to subscribe to a non-existant event raises an exception (issue #3) (@GustavoCaso + @mensfeld)

[Compare v0.1.1...v0.2.0](https://github.com/dry-rb/dry-events/compare/v0.1.1...v0.2.0)

# v0.1.1 2019-03-22

## Added

- Subscription filters can be more complex: nested hash inclusion, array inclusion, and proc checks were added (flash-gordon)
  ```ruby
  # nested hash check
  subscribe(:event, logger: { level: :info })
  # pass
  trigger(:event, logger: { level: :info, output: :stdin })
  # filtered out
  trigger(:event, logger: { level: :debug })
  trigger(:event, something: :else)

  # array inclusion
  subscribe(:event, logger: { level: %i(info warn error) })
  # pass
  trigger(:event, logger: { level: :info })
  trigger(:event, logger: { level: :error })
  trigger(:event, logger: { level: :info, output: :stdin })
  # filtered out
  trigger(:event, logger: { level: :debug })

  # proc checks
  # here acts as array inclusion example
  subscribe(:event, logger: { level: -> level { %i(info warn error).include?(level) })
  ```

[Compare v0.1.0...v0.1.1](https://github.com/dry-rb/dry-events/compare/v0.1.0...v0.1.1)

# v0.1.0 2018-01-02

First public release
