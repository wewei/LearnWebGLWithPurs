module Behavior
  ( Behavior
  , Pulse
  , peek
  , counter
  , class Subscribe
  , subscribe
  , integral
  , differential
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

foreign import peek :: forall a. Behavior a -> Effect a

foreign import counter :: Number -> Effect (Behavior Int) 

-- | Pulse
foreign import data Pulse :: Type -> Type

foreign import map_Pulse :: forall a b. (a -> b) -> Pulse a -> Pulse b

instance Functor Pulse where
    map = map_Pulse

foreign import apply_Pulse :: forall a b. Pulse (a -> b) -> Pulse a -> Pulse b
instance Apply Pulse where
    apply = apply_Pulse

foreign import pure_Pulse :: forall a. a -> Pulse a
instance Applicative Pulse where
    pure = pure_Pulse

foreign import bind_Pulse :: forall a b. Pulse a -> (a -> Pulse b) -> Pulse b
instance Bind Pulse where
    bind = bind_Pulse

instance Monad Pulse
foreign import subscribe_Pulse :: forall a. Pulse a -> (a -> Effect Unit) -> Effect (Effect Unit)

instance Subscribe Pulse where
    subscribe = subscribe_Pulse

foreign import once :: forall a. Pulse a -> (a -> Effect Unit) -> Effect Unit

foreign import integral :: forall a b. (a -> b -> b) -> Pulse a -> b -> Effect (Behavior b)

foreign import differential :: forall a b. (a -> a -> b) -> Behavior a -> Pulse b