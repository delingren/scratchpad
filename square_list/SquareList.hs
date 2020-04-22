module Main where
import Data.List

squares :: Int -> [Int]
squares n = takeWhile (< n*2) (map (\i -> i*i) [2..])

solveTail :: Int -> [Int] -> [[Int]]
solveTail _ [] = []
solveTail _ [x] = [[x]]
solveTail size (x:xs) = [x:y:ys | y <- nexts, (_:ys) <- solveTail size (y:delete y xs)]
   where nexts = [y | y <- xs, elem (x+y) (squares size)]

solve :: Int -> [[Int]]
solve size = let xs = [1..size] in concat [solveTail size (x:delete x xs) | x <- xs]

solveFirst :: Int -> Maybe [Int]
solveFirst size = 
    case solve size of
        [] -> Nothing
        xs:_ -> Just xs

main :: IO [()]
main = sequence [do print n; print (solveFirst n) | n <- [1..100]]
