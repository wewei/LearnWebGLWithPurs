module Reactive.Convert where

import Effect (Effect)
import Reactive.Behavior (Behavior)
import Reactive.Series (Series)

foreign import accum :: forall a b. (a -> b -> b) -> Series a -> b -> Effect (Behavior b)

foreign import diff :: forall a b. (a -> a -> b) -> Behavior a -> Series b