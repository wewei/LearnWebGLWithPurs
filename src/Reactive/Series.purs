module Reactive.Series where

import Reactive.Observable
import Effect (Effect)
import Prelude (class Functor, Unit)

foreign import data Series :: Type -> Type

foreign import mapSeries :: forall a b. (a -> b) -> Series a -> Series b

instance Functor Series where
    map = mapSeries

foreign import observeSeries :: forall a. Series a -> (a -> Effect Unit) -> Effect (Effect Unit)

instance Observable Series where
    observe = observeSeries
