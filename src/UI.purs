module UI where

import Prelude

import Behavior (Behavior, peek)
import Effect (Effect)

data UISystem v e = UISystem
    { paint :: Behavior v -> Effect e
    }

data Component v e t = Component
    { render  :: t -> Behavior v
    , resolve :: e -> t -> Behavior t
    , initial :: Behavior t
    }

runApp :: forall v e t . UISystem v e -> Component v e t -> Effect Unit
runApp  (UISystem { paint })
        (Component { render, resolve, initial }) =
        runLoop initial
            where
                runLoop :: Behavior t -> Effect Unit
                runLoop bhT = do
                    e <- paint (bhT >>= render)
                    t <- peek bhT
                    runLoop $ resolve e t

