module Reactive.Behavior (Behavior) where

import Prelude (class Applicative, class Apply, class Bind, class Functor, class Monad, Unit)
import Reactive.Observable (class Observable)
import Reactive.Peekable (class Peekable)
import Effect (Effect)

foreign import data Behavior :: Type -> Type

foreign import mapBehavior :: forall a b. (a -> b) -> Behavior a -> Behavior b

instance Functor Behavior where 
    map = mapBehavior

foreign import applyBehavior :: forall a b. Behavior (a -> b) -> Behavior a -> Behavior b

instance Apply Behavior where
    apply = applyBehavior

foreign import pureBehavior :: forall a. a -> Behavior a

instance Applicative Behavior where
    pure = pureBehavior

foreign import bindBehavior :: forall a b. Behavior a -> (a -> Behavior b) -> Behavior b

instance Bind Behavior where
    bind = bindBehavior

instance Monad Behavior

foreign import observeBehavior :: forall a. Behavior a -> (a -> Effect Unit) -> Effect (Effect Unit)

instance Observable Behavior where
    observe = observeBehavior

foreign import peekBehavior :: forall a. Behavior a -> Effect a

instance Peekable Behavior where
    peek = peekBehavior

