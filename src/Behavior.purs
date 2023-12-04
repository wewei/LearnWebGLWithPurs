module Behavior
  ( Behavior
  , observe
  , peek
  , counter
  )
  where

import Prelude

import Effect (Effect)

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

foreign import observe :: forall a. Behavior a -> (a -> Effect Unit) -> Effect Unit

foreign import peek :: forall a. Behavior a -> Effect a

foreign import counter :: Number -> Effect (Behavior Int) 
