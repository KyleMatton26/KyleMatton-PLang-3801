module Exercises
    ( change,
      firstThenApply,
      powers,
      meaningfulLineCount,
      volume,
      surfaceArea,
      Shape(..),
      BST(..),
      inorder,
      insert,
      size,
      contains
    ) where

import qualified Data.Map as Map
import Data.Text (pack, unpack, replace, empty)
import Data.List(isPrefixOf, find)
import Data.Char(isSpace)

change :: Integer -> Either String (Map.Map Integer Integer)
change amount
    | amount < 0 = Left "amount cannot be negative"
    | otherwise = Right $ changeHelper [25, 10, 5, 1] amount Map.empty
        where
          changeHelper [] remaining counts = counts
          changeHelper (d:ds) remaining counts =
            changeHelper ds newRemaining newCounts
              where
                (count, newRemaining) = remaining `divMod` d
                newCounts = Map.insert d count counts

firstThenApply :: [a] -> (a -> Bool) -> (a -> b) -> Maybe b
firstThenApply a p f = f <$> find p a

powers :: Integral a => a -> [a]
powers b = map (b^) [0..]

meaningfulLineCount :: FilePath -> IO Int
meaningfulLineCount path = do
    contents <- readFile path
    let ls = lines contents
        filtered = filter (\line -> not (null line) && not (all isSpace line) && ((/='#') . head . dropWhile isSpace) line) ls
    return (length filtered)


data Shape = Sphere Double | Box Double Double Double deriving (Eq, Show)

volume :: Shape -> Double
volume (Sphere r) = (4.0 / 3.0) * pi * r^3
volume (Box l w h) = l * w * h

surfaceArea :: Shape -> Double
surfaceArea (Sphere r) = 4.0 * pi * r^2
surfaceArea (Box l w h) = 2.0 * (l*w + l*h + w*h)


data BST a = Empty | Node (BST a) a (BST a)

instance Show a => Show (BST a) where
  show Empty = "()"
  show (Node left v right) = "(" ++ show' left ++ show v ++ show' right ++ ")"
    where
      show' Empty = ""
      show' t = show t

size :: BST a -> Int
size Empty = 0
size (Node left _ right) = 1 + size left + size right

contains :: Ord a => a -> BST a -> Bool
contains _ Empty = False
contains x (Node left v right)
  | x == v    = True
  | x < v     = contains x left
  | otherwise = contains x right

inorder :: BST a -> [a]
inorder Empty = []
inorder (Node left v right) = inorder left ++ [v] ++ inorder right

insert :: Ord a => a -> BST a -> BST a
insert x Empty = Node Empty x Empty
insert x (Node left v right)
  | x < v     = Node (insert x left) v right
  | x > v     = Node left v (insert x right)
  | otherwise = Node left v right

to_string :: Show a => BST a -> String
to_string = show
