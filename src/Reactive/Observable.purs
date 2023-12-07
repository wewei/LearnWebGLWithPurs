module Reactive.Observable 
  ( class Observable
  , observe
  ) where

import Effect (Effect)
import Prelude (Unit)

class Observable o where
    observe :: forall a. o a -> (a -> Effect Unit) -> Effect (Effect Unit)

