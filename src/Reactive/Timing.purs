module Reactive.Timing (counter) where

import Effect (Effect)
import Reactive.Behavior (Behavior)

foreign import counter :: Number -> Effect (Behavior Int) 