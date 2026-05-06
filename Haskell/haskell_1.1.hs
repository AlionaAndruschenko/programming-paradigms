--18. Вилучити зі списку елементи, що входять у нього по одному разу.
removeSingles :: Eq a => [a] -> [a]
removeSingles xs = [x | x <- xs, getCount x counts /= 1]
  where
    counts = buildCounts xs

buildCounts :: Eq a => [a] -> [(a, Int)]
buildCounts [] = []
buildCounts (x:xs) = addCount x (buildCounts xs)

addCount :: Eq a => a -> [(a, Int)] -> [(a, Int)]
addCount x [] = [(x,1)]
addCount x ((y,n):ys)
    | x == y    = (y,n+1):ys
    | otherwise = (y,n) : addCount x ys

getCount :: Eq a => a -> [(a, Int)] -> Int
getCount _ [] = 0
getCount x ((y,n):ys)
    | x == y    = n
    | otherwise = getCount x ys

main :: IO ()
main = do
    let xs = [1, 2, 3, 2, 4, 3, 5, 1, 6, 7, 6, 8, 9, 9, 9]
    print (removeSingles xs)
