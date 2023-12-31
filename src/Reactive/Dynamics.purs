module Reactive.Dynamics
  ( accum
  , diff
  , react
  )
  where

import Effect (Effect)
import Prelude (join, map, pure, (<<<), (>>=), class Monad)
import Reactive.Behavior (Behavior)
import Reactive.Peekable (class Peekable, peek)
import Reactive.Series (Series)

foreign import accum :: forall a b. (a -> b -> b) -> b -> Series a -> Effect (Behavior b)

foreign import diff :: forall a b. (a -> a -> b) -> Behavior a -> Series b

react :: forall a b p. Peekable p => Monad p => (a -> b -> p b) -> Series a -> p b -> Effect (p b)
react f ser =
    -- Effect (Behavior b)
    join
    -- Effect (Effect (Behavior b))
    <<< map (join <<< peek)
    -- Effect (Behavior (Effect (Behavior b)))
    <<< (\eb -> accum g eb ser)
    -- Effect (Behavior b)
    <<< pure
    -- Behavior b
    where
        g a eb = eb >>= map (f a) <<< peek
