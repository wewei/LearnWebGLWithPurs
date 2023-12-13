module Reactive2.Future.Timing where

import Prelude (Unit, pure, unit, void, ($), (>>=), const)
import Reactive2.Future (Future(..))

import Effect.Timer (setTimeout)

sleep :: Int -> Future Unit
sleep ms = Future $ pure $ \hdl -> void $ setTimeout ms (hdl unit)

delay :: forall a. Int -> Future a -> Future a
delay ms fut = fut >>= \a -> sleep ms
                   >>= const (pure a)

