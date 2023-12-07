module Reactive.Peekable
  ( class Peekable
  , peek
  ) where

import Effect (Effect)

class Peekable p where
    peek :: forall a. p a -> Effect a
