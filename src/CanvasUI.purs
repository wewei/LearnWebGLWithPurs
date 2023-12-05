module CanvasUI where

import Prelude

import Effect (Effect)
import Graphics.Canvas (ImageData, imageDataHeight, imageDataWidth)

type Point2D = { x :: Number, y :: Number }

data MouseKey = MouseLeft | MouseMiddle | MouseRight

class Paintable a where 
    image :: a -> ImageData

width :: forall a. Paintable a => a -> Int
width = imageDataWidth <<< image

height :: forall a. Paintable a => a -> Int
height = imageDataHeight <<< image

class KeyTarget a where
    onKeyDown :: Number -> a -> Effect Unit
    onKeyUp :: Number -> a -> Effect Unit

class MouseTarget a where
    onMouseDown :: MouseKey -> Point2D -> a -> Effect Unit
    onMouseUp :: MouseKey -> Point2D -> a -> Effect Unit
    onMouseMove :: Point2D -> a -> Effect Unit
    onMouseIn :: Int -> a -> Effect Unit
    onMouseOut :: Int -> a -> Effect Unit

class (Paintable a, KeyTarget a, MouseTarget a) <= View a

-- | A view represents a rect range that handles the mouse, keyboard and touch events