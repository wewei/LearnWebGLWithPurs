module Behavior
  ( Behavior
  , observe
  , counter
  , class Subscribe
  , subscribe
  )
  where

import Prelude

import Effect (Effect)

class Subscribe s where
    subscribe :: forall a. s a -> (a -> Effect Unit) -> Effect (Effect Unit)

foreign import data Behavior :: Type -> Type

foreign import map_Behavior :: forall a b. (a -> b) -> Behavior a -> Behavior b

instance Functor Behavior where 
    map = map_Behavior

foreign import apply_Behavior :: forall a b. Behavior (a -> b) -> Behavior a -> Behavior b

instance Apply Behavior where
    apply = apply_Behavior

foreign import pure_Behavior :: forall a. a -> Behavior a

instance Applicative Behavior where
    pure = pure_Behavior

foreign import bind_Behavior :: forall a b. Behavior a -> (a -> Behavior b) -> Behavior b

instance Bind Behavior where
    bind = bind_Behavior

instance Monad Behavior

foreign import subscribe_Behavior :: forall a. Behavior a -> (a -> Effect Unit) -> Effect (Effect Unit)

instance Subscribe Behavior where
    subscribe = subscribe_Behavior

foreign import observe :: forall a. Behavior a -> Effect a

foreign import counter :: Number -> Effect (Behavior Int) 

-- | Pulse
foreign import data Pulse :: Type -> Type

foreign import map_Pulse :: forall a b. (a -> b) -> Pulse a -> Pulse b

instance Functor Pulse where
    map = map_Pulse

foreign import subscribe_Pulse :: forall a. Pulse a -> (a -> Effect Unit) -> Effect (Effect Unit)

instance Subscribe Pulse where
    subscribe = subscribe_Pulse

foreign import once :: forall a. Pulse a -> (a -> Effect Unit) -> Effect Unit
